package com.doa.example.devicebinding.flutter

import android.os.Build
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.security.keystore.UserNotAuthenticatedException
import android.util.Base64
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.fragment.app.FragmentActivity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.security.KeyPair
import java.security.KeyPairGenerator
import java.security.KeyStore
import java.security.PrivateKey
import java.security.Signature
import java.security.cert.Certificate
import java.security.spec.ECGenParameterSpec

/**
 * Port of `services/DeviceBinding.kt` from the Kotlin example, exposed to Dart
 * over a [MethodChannel].
 *
 * The class body below is the original almost verbatim — hardware-backed keys
 * are non-exportable by design, so the KeyStore work cannot move to Dart. Only
 * the entry points changed: each public function is now a channel method, and
 * `getDeviceAttestationsKey` returns the encoded chain rather than a
 * `DeviceAttestationDto`, which the Dart side assembles from the generated
 * model.
 *
 * **The phone-key profile (variant C).** `generateECKeyPair` takes
 * `biometricGated`. When it is set the device key itself demands a strong
 * biometric, is invalidated when enrolment changes, and stays usable for 600
 * seconds after one authentication - one prompt per ten-minute session, which
 * is what makes that profile's promise hardware-enforced rather than a UI
 * claim. Nothing about the customer profile changes: without the flag the key
 * is exactly the key it always was.
 */
class DeviceBindingChannel(private val activity: FragmentActivity) {
    private val keystoreProvider = "AndroidKeyStore"
    // Loaded here, not lazily on the `initializeKeyStore` call. Every other
    // method below touches `ks`, and an unloaded KeyStore throws
    // `KeyStoreException: Uninitialized keystore`, so deferring it would make
    // correctness depend on Dart calling `initializeKeyStore` first - an
    // implicit ordering invariant across the language boundary that breaks
    // under any hosting model where `configureFlutterEngine` runs more than
    // once per Dart `main()` (cached engines, FlutterEngineGroup, add-to-app).
    // Matches `BiometricBindingChannel`, which already does this.
    private val ks: KeyStore = KeyStore.getInstance(keystoreProvider).apply { load(null) }

    fun register(messenger: BinaryMessenger): MethodChannel {
        val channel = MethodChannel(messenger, CHANNEL)
        channel.setMethodCallHandler { call, result -> handle(call, result) }
        return channel
    }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                // Retained for parity with `services/DeviceBinding.kt` and with the
                // Dart API. The constructor has already loaded the store, so this is
                // idempotent and no longer order-sensitive.
                "initializeKeyStore" -> {
                    ks.load(null)
                    result.success(null)
                }

                "generateECKeyPair" -> {
                    generateECKeyPair(
                        call.arg("identifier"),
                        call.arg("challenge"),
                        call.argument<Boolean>("biometricGated") ?: false,
                    )
                    result.success(null)
                }

                "getDeviceAttestationsKey" ->
                    result.success(getDeviceAttestationsKey(call.arg("identifier")))

                // May prompt, so it answers through a lifecycle-bound result: a
                // host destroyed while the prompt is up must report an error
                // rather than leave Dart awaiting the call forever.
                "sign" -> {
                    val bound = LifecycleBoundResult(activity, result, ERROR_CODE)
                    try {
                        sign(call.arg("data"), call.arg("identifier"), bound)
                    } catch (e: Exception) {
                        bound.error(ERROR_CODE, e.message, e.toString())
                    }
                }

                // The prompt alone: opens a gated key's window without signing.
                // The phone-key journey calls it at every session start, because
                // a window already opened by unlocking the phone would otherwise
                // let a sign-in through without asking.
                "unlock" -> {
                    val bound = LifecycleBoundResult(activity, result, ERROR_CODE)
                    try {
                        prompt(bound) { bound.success(null) }
                    } catch (e: Exception) {
                        bound.error(ERROR_CODE, e.message, e.toString())
                    }
                }

                "reset" -> {
                    reset(call.arg("identifier"))
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            // Surfaces in Dart as a PlatformException, which the controllers
            // funnel through `describeApiError`.
            result.error("device_binding_error", e.message, e.toString())
        }
    }

    private fun generateECKeyPair(
        identifier: String,
        challenge: String,
        biometricGated: Boolean,
    ): KeyPair {
        val keyAlias = createKeyAlias(identifier)
        if (ks.containsAlias(keyAlias)) {
            require(!identifier.startsWith("customer.")) { "Existing customer key must not be replaced" }
            ks.deleteEntry(keyAlias)
        }

        val keyPairGenerator =
            KeyPairGenerator.getInstance(KeyProperties.KEY_ALGORITHM_EC, keystoreProvider)

        val builder = KeyGenParameterSpec.Builder(
            keyAlias,
            KeyProperties.PURPOSE_SIGN,
        )
            .setAlgorithmParameterSpec(ECGenParameterSpec("secp256r1")) // P-256
            .setDigests(KeyProperties.DIGEST_SHA256).setKeySize(256)
            .setAttestationChallenge(challenge.toByteArray())

        if (biometricGated) {
            // One authentication unlocks signing for the length of one session.
            // Strong biometrics only, and the key dies when enrolment changes,
            // so "this phone is your key" is enforced by the secure hardware
            // rather than promised by the UI.
            builder.setUserAuthenticationRequired(true)
                .setInvalidatedByBiometricEnrollment(true)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                builder.setUserAuthenticationParameters(
                    AUTH_VALIDITY_SECONDS,
                    KeyProperties.AUTH_BIOMETRIC_STRONG,
                )
            } else {
                // API 28-29 has no way to say "biometrics only" for a
                // time-bound key; the duration form is the closest equivalent.
                @Suppress("DEPRECATION")
                builder.setUserAuthenticationValidityDurationSeconds(AUTH_VALIDITY_SECONDS)
            }
        }

        keyPairGenerator.initialize(builder.build())

        val pair = keyPairGenerator.generateKeyPair()
        if (identifier.startsWith("customer.")) {
            val info = java.security.KeyFactory.getInstance(pair.private.algorithm, keystoreProvider)
                .getKeySpec(pair.private, android.security.keystore.KeyInfo::class.java)
            if (!info.isInsideSecureHardware) {
                ks.deleteEntry(keyAlias)
                throw IllegalStateException("Hardware-backed keys are required")
            }
            if (biometricGated && !info.isUserAuthenticationRequirementEnforcedBySecureHardware) {
                ks.deleteEntry(keyAlias)
                throw IllegalStateException("Hardware-enforced biometrics are required")
            }
        }
        return pair
    }

    /**
     * The certificate chain consists of an array of certificates, thus we concat
     * them into a string - see [encodeCertificateChain], shared with the
     * biometric key's attestation.
     */
    private fun getDeviceAttestationsKey(identifier: String): String {
        val keyAlias = createKeyAlias(identifier)
        val chain = getCertificateChain(keyAlias)
            ?: throw IllegalStateException("Certificate chain not found for identifier: $identifier")
        return encodeCertificateChain(chain)
    }

    private fun getDevicePrivateKey(keyAlias: String): PrivateKey? {
        return try {
            ks.getKey(keyAlias, null) as PrivateKey
        } catch (e: Exception) {
            throw RuntimeException("Exception: ", e)
        }
    }

    private fun getCertificateChain(keyAlias: String): Array<out Certificate>? {
        return try {
            ks.getCertificateChain(keyAlias)
        } catch (e: Exception) {
            throw RuntimeException("Exception: ", e)
        }
    }

    private fun createKeyAlias(identifier: String): String = "key_id_$identifier"

    /**
     * Signs with the device key, prompting first when the key demands it.
     *
     * A plain key signs straight away. A biometric-gated one throws
     * [UserNotAuthenticatedException] until the user has authenticated inside
     * its validity window; then a prompt runs and the signature is produced
     * afterwards. The prompt carries **no** `CryptoObject`: that binding is for
     * per-use keys, and a time-bound key rejects it - the authentication itself
     * is what opens the window, and the `Signature` is initialised after it.
     */
    private fun sign(data: String, identifier: String, result: LifecycleBoundResult) {
        val keyAlias = createKeyAlias(identifier)
        try {
            result.success(signNow(keyAlias, data))
        } catch (e: UserNotAuthenticatedException) {
            promptThenSign(keyAlias, data, result)
        }
    }

    private fun signNow(keyAlias: String, data: String): String {
        val signature = Signature.getInstance("SHA256withECDSA")
        // Throws UserNotAuthenticatedException here for a gated key outside its
        // window, which is exactly the signal the caller above waits for.
        signature.initSign(getDevicePrivateKey(keyAlias))
        signature.update(data.toByteArray())
        return Base64.encodeToString(signature.sign(), Base64.DEFAULT)
    }

    private fun promptThenSign(
        keyAlias: String,
        data: String,
        result: LifecycleBoundResult,
    ) = prompt(result) {
        try {
            result.success(signNow(keyAlias, data))
        } catch (e: Exception) {
            result.error(ERROR_CODE, e.message, e.toString())
        }
    }

    /**
     * The strong-biometric prompt on its own. A successful authentication
     * opens the gated key's window, which is what both callers rely on: `sign`
     * when the keystore refused, and `unlock`, which the phone-key journey calls
     * at every session start because a window opened by unlocking the phone
     * would otherwise let a sign-in pass without asking.
     */
    private fun prompt(result: LifecycleBoundResult, onAuthenticated: () -> Unit) {
        val prompt = BiometricPrompt(
            activity,
            activity.mainExecutor,
            object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationSucceeded(
                    authResult: BiometricPrompt.AuthenticationResult,
                ) {
                    onAuthenticated()
                }

                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                    // The same code shape the biometric channel uses, so Dart
                    // tells a dismissed prompt from a failure without parsing text.
                    result.error(
                        "biometric_error_$errorCode",
                        "Biometric error $errorCode: $errString",
                        null,
                    )
                }

                override fun onAuthenticationFailed() {
                    // The user may retry; an error or a success still follows.
                }
            },
        )
        val info = BiometricPrompt.PromptInfo.Builder()
            .setTitle("Unlock azuma")
            .setSubtitle("This phone is your key")
            .setNegativeButtonText("Cancel")
            .setAllowedAuthenticators(BiometricManager.Authenticators.BIOMETRIC_STRONG)
            .build()
        prompt.authenticate(info)
    }

    private fun reset(identifier: String) {
        val keyAlias = createKeyAlias(identifier)
        if (ks.containsAlias(keyAlias)) {
            ks.deleteEntry(keyAlias)
        }
    }

    companion object {
        /** Must match `DeviceBinding._channel` in `lib/src/services/device_binding.dart`. */
        const val CHANNEL = "com.doa.example.devicebinding.flutter/device_binding"
        private const val ERROR_CODE = "device_binding_error"

        /** One prompt covers one ten-minute session (variants.md, C). */
        private const val AUTH_VALIDITY_SECONDS = 600
    }
}

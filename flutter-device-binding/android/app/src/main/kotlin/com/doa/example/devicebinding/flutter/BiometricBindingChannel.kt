package com.doa.example.devicebinding.flutter

import android.os.Build
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.security.keystore.StrongBoxUnavailableException
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
import java.security.PublicKey
import java.security.Signature
import java.security.spec.ECGenParameterSpec
import java.util.concurrent.Executor

/**
 * Port of `services/BiometricBinding.kt`, exposed to Dart over a [MethodChannel].
 *
 * Generates and uses a biometric-gated key in the AndroidKeyStore for the
 * `/api/biometric/link` and `/api/biometric/login` endpoints.
 *
 * The server (doa-organization) accepts both algorithms — EC P-256 is the
 * default and matches StrongBox/Secure-Enclave-class hardware on iOS;
 * RSA-3072 is provided for parity with libraries like `react-native-biometrics`
 * that don't expose EC (note: that library itself uses RSA-2048 — this sample
 * generates a stronger 3072-bit key, which still satisfies the server's
 * >=2048-bit minimum).
 *
 * The signature returned by SHA256withECDSA / SHA256withRSA is the format the
 * server expects (RFC 3279 DER for ECDSA, PKCS#1 v1.5 for RSA); both are
 * passed through `Base64.encode(..., Base64.NO_WRAP)` for the `requestSignature`
 * field.
 *
 * `BiometricPrompt` binds the `Signature` object it authorises, so prompting and
 * signing stay a single call — that pairing is why this cannot be a Dart-side
 * `local_auth` call followed by a separate sign.
 */
class BiometricBindingChannel(private val activity: FragmentActivity) {
    enum class Algorithm { EC_P256, RSA_3072 }

    private val keystoreProvider = "AndroidKeyStore"
    private val keystore: KeyStore = KeyStore.getInstance(keystoreProvider).apply { load(null) }

    fun register(messenger: BinaryMessenger): MethodChannel {
        val channel = MethodChannel(messenger, CHANNEL)
        channel.setMethodCallHandler { call, result -> handle(call, result) }
        return channel
    }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "canAuthenticate" -> result.success(canAuthenticate())

                "generateBiometricKey" -> {
                    val algorithm = Algorithm.valueOf(call.arg("algorithm"))
                    result.success(
                        generateBiometricKey(call.arg("alias"), algorithm, call.argument<String>("challenge"))
                    )
                }

                // Asynchronous: the prompt calls back on the main thread and the
                // result is completed from there. Wrapped so a destroyed activity
                // reports an error instead of abandoning the call - see
                // [LifecycleBoundResult].
                //
                // Its own try/catch, not the outer one: the wrapper registers a
                // lifecycle observer as soon as it is constructed, so a throw out
                // of `signChallenge` - `detectAlgorithm` on an alias that was
                // never linked, say - must be answered through the wrapper too.
                // Answering the raw `result` here would leave the observer armed
                // to answer it a second time on destroy.
                "signChallenge" -> {
                    val bound = LifecycleBoundResult(activity, result, ERROR_CODE)
                    try {
                        signChallenge(
                            alias = call.arg("alias"),
                            challenge = call.arg("challenge"),
                            promptTitle = call.arg("promptTitle"),
                            promptSubtitle = call.arg("promptSubtitle"),
                            result = bound,
                        )
                    } catch (e: Exception) {
                        bound.error(ERROR_CODE, e.message, e.toString())
                    }
                }

                "reset" -> {
                    reset(call.arg("alias"))
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error(ERROR_CODE, e.message, e.toString())
        }
    }

    private fun canAuthenticate(): Boolean =
        BiometricManager.from(activity)
            .canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_STRONG) ==
            BiometricManager.BIOMETRIC_SUCCESS

    /**
     * Creates a biometric-gated key under [alias] using the given [algorithm].
     * Returns `publicKey`, the base64 SubjectPublicKeyInfo for
     * `DeviceBindingBiometricsLinkRequest.publicKey`, and - when a server
     * [challenge] is given - `attestation`, the AndroidKeyStore attestation chain
     * over it, encoded like the device key's `DeviceAttestationDto.attestation`.
     *
     * The chain is what lets DOA verify the biometric factor instead of taking
     * the client's word for it: its hardware-enforced list records the security
     * level, the challenge, and that the key demands biometric authentication on
     * every use (DOA does not read it yet). Without a challenge the keystore issues only a
     * self-signed placeholder certificate, so no chain is returned.
     *
     * `setUserAuthenticationRequired(true)` forces a fresh biometric prompt
     * for every `signChallenge(...)` call below.
     */
    private fun generateBiometricKey(alias: String, algorithm: Algorithm, challenge: String?): Map<String, String> {
        if (keystore.containsAlias(alias)) {
            require(!alias.startsWith("customer.")) { "Existing customer key must not be replaced" }
            keystore.deleteEntry(alias)
        }

        val builder = KeyGenParameterSpec.Builder(alias, KeyProperties.PURPOSE_SIGN)
            .setDigests(KeyProperties.DIGEST_SHA256)
            .setUserAuthenticationRequired(true)
            .setInvalidatedByBiometricEnrollment(true)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            builder.setUserAuthenticationParameters(0, KeyProperties.AUTH_BIOMETRIC_STRONG)
        }
        if (challenge != null) {
            builder.setAttestationChallenge(challenge.toByteArray(Charsets.UTF_8))
        }

        val keyAlgorithm = when (algorithm) {
            Algorithm.EC_P256 -> {
                builder.setAlgorithmParameterSpec(ECGenParameterSpec("secp256r1"))
                KeyProperties.KEY_ALGORITHM_EC
            }

            Algorithm.RSA_3072 -> {
                builder.setKeySize(3072)
                    .setSignaturePaddings(KeyProperties.SIGNATURE_PADDING_RSA_PKCS1)
                KeyProperties.KEY_ALGORITHM_RSA
            }
        }

        val pair = generateKeyPair(keyAlgorithm, builder)
        if (alias.startsWith("customer.")) {
            val info = java.security.KeyFactory.getInstance(pair.private.algorithm, keystoreProvider)
                .getKeySpec(pair.private, android.security.keystore.KeyInfo::class.java)
            if (!info.isInsideSecureHardware || !info.isUserAuthenticationRequirementEnforcedBySecureHardware) {
                keystore.deleteEntry(alias)
                throw IllegalStateException("Hardware-enforced biometrics are required")
            }
        }
        val material = mutableMapOf("publicKey" to exportSpkiBase64(pair.public))
        if (challenge != null) {
            val chain = keystore.getCertificateChain(alias)
                ?: throw IllegalStateException("No attestation chain for alias '$alias'")
            material["attestation"] = encodeCertificateChain(chain)
        }
        return material
    }

    /**
     * Generates the key pair, preferring a StrongBox-backed key on API 30+.
     * StrongBox is not emulated and is missing on many real devices; when it is,
     * [KeyPairGenerator.generateKeyPair] throws [StrongBoxUnavailableException]
     * rather than falling back, so we retry once with StrongBox disabled. The key
     * still lands in the TEE-backed AndroidKeyStore either way.
     */
    private fun generateKeyPair(keyAlgorithm: String, builder: KeyGenParameterSpec.Builder): KeyPair {
        fun generate(useStrongBox: Boolean): KeyPair {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                builder.setIsStrongBoxBacked(useStrongBox)
            }
            return KeyPairGenerator.getInstance(keyAlgorithm, keystoreProvider).apply {
                initialize(builder.build())
            }.generateKeyPair()
        }

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
            return generate(useStrongBox = false)
        }
        return try {
            generate(useStrongBox = true)
        } catch (e: StrongBoxUnavailableException) {
            generate(useStrongBox = false)
        }
    }

    /**
     * Signs UTF-8([challenge]) with the key stored under [alias], gated by a
     * biometric prompt, and completes [result] with the signature base64-encoded
     * — the value for `requestSignature` on link or login.
     *
     * For EC keys the underlying signature is `SHA256withECDSA`, which the JDK
     * emits as a DER-encoded `SEQUENCE { r, s }` (RFC 3279) — exactly what the
     * server's ECDSA verifier expects.
     *
     * The Kotlin example suspends on the prompt callback; a MethodChannel
     * handler cannot, so the [MethodChannel.Result] is completed from the
     * callback instead. Handlers already run on the platform thread, which is
     * the main thread BiometricPrompt requires.
     */
    private fun signChallenge(
        alias: String,
        challenge: String,
        promptTitle: String,
        promptSubtitle: String,
        result: LifecycleBoundResult,
    ) {
        val algorithm = detectAlgorithm(alias)
        val signature = Signature.getInstance(
            when (algorithm) {
                Algorithm.EC_P256 -> "SHA256withECDSA"
                Algorithm.RSA_3072 -> "SHA256withRSA"
            }
        )
        signature.initSign(loadPrivateKey(alias))

        val executor: Executor = activity.mainExecutor
        val prompt = BiometricPrompt(activity, executor, object : BiometricPrompt.AuthenticationCallback() {
            override fun onAuthenticationSucceeded(authResult: BiometricPrompt.AuthenticationResult) {
                try {
                    val sig = authResult.cryptoObject?.signature
                        ?: throw IllegalStateException(
                            "BiometricPrompt result is missing the bound Signature object"
                        )
                    sig.update(challenge.toByteArray(Charsets.UTF_8))
                    result.success(Base64.encodeToString(sig.sign(), Base64.NO_WRAP))
                } catch (e: Exception) {
                    result.error(ERROR_CODE, e.message, e.toString())
                }
            }

            override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                result.error("biometric_error_$errorCode", "Biometric error $errorCode: $errString", null)
            }

            override fun onAuthenticationFailed() {
                // User can retry — onAuthenticationError or onAuthenticationSucceeded will eventually fire.
            }
        })

        val info = BiometricPrompt.PromptInfo.Builder()
            .setTitle(promptTitle)
            .setSubtitle(promptSubtitle)
            .setNegativeButtonText("Cancel")
            .setAllowedAuthenticators(BiometricManager.Authenticators.BIOMETRIC_STRONG)
            .build()

        prompt.authenticate(info, BiometricPrompt.CryptoObject(signature))
    }

    private fun reset(alias: String) {
        if (keystore.containsAlias(alias)) keystore.deleteEntry(alias)
    }

    private fun loadPrivateKey(alias: String): PrivateKey =
        keystore.getKey(alias, null) as? PrivateKey
            ?: throw IllegalStateException("No biometric key found under alias '$alias'")

    private fun detectAlgorithm(alias: String): Algorithm =
        when (keystore.getCertificate(alias).publicKey.algorithm) {
            "EC" -> Algorithm.EC_P256
            "RSA" -> Algorithm.RSA_3072
            else -> throw IllegalStateException("Unsupported key algorithm for alias '$alias'")
        }

    /** `PublicKey.getEncoded()` for both EC and RSA AndroidKeyStore keys is X.509 SubjectPublicKeyInfo (DER). */
    private fun exportSpkiBase64(publicKey: PublicKey): String =
        Base64.encodeToString(publicKey.encoded, Base64.NO_WRAP)

    companion object {
        /** Must match `BiometricBinding._channel` in `lib/src/services/biometric_binding.dart`. */
        const val CHANNEL = "com.doa.example.devicebinding.flutter/biometric_binding"

        private const val ERROR_CODE = "biometric_binding_error"
    }
}

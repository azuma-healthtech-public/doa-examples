package com.doa.example.devicebinding.flutter

import androidx.credentials.CreatePublicKeyCredentialRequest
import androidx.credentials.CredentialManager
import androidx.credentials.GetCredentialRequest
import androidx.credentials.GetPublicKeyCredentialOption
import androidx.credentials.exceptions.CreateCredentialCancellationException
import androidx.credentials.exceptions.publickeycredential.CreatePublicKeyCredentialDomException
import androidx.credentials.exceptions.publickeycredential.GetPublicKeyCredentialDomException
import androidx.credentials.exceptions.domerrors.SecurityError
import androidx.credentials.exceptions.GetCredentialCancellationException
import androidx.credentials.exceptions.NoCredentialException
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.lifecycleScope
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch

/**
 * The `androidx.credentials` calls the Kotlin example makes inline in
 * `LoginPasskeyActivity` and `WelcomeActivity`, lifted into a [MethodChannel].
 *
 * Credential Manager needs an `Activity` to host its system UI, which is why
 * this lives on the platform side rather than behind a pub package. Options and
 * responses cross the boundary as the opaque JSON strings the server produced
 * and expects back — nothing here parses or re-serialises them, so the bytes the
 * relying party signed over are the bytes it verifies.
 */
class PasskeyChannel(private val activity: FragmentActivity) {
    private val credentialManager by lazy { CredentialManager.create(activity) }

    fun register(messenger: BinaryMessenger): MethodChannel {
        val channel = MethodChannel(messenger, CHANNEL)
        channel.setMethodCallHandler { call, result -> handle(call, result) }
        return channel
    }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getCredential" -> launchCredentialRequest(result) {
                val option = GetPublicKeyCredentialOption(call.arg<String>("requestJson"))
                val response = credentialManager.getCredential(
                    activity,
                    GetCredentialRequest(listOf(option)),
                )
                response.credential.data.getString(AUTHENTICATION_RESPONSE_JSON)
                    ?: throw IllegalStateException(
                        "Failed to get assertion response from Credential Manager"
                    )
            }

            "createCredential" -> launchCredentialRequest(result) {
                val request = CreatePublicKeyCredentialRequest(call.arg<String>("requestJson"))
                val response = credentialManager.createCredential(activity, request)
                response.data.getString(REGISTRATION_RESPONSE_JSON)
                    ?: throw IllegalStateException("Failed to get registration response")
            }

            else -> result.notImplemented()
        }
    }

    /**
     * `CredentialManager`'s API is `suspend`, so the call runs on the activity's
     * lifecycle scope and completes [result] when it returns. A user who
     * dismisses the system sheet surfaces as a `GetCredentialCancellationException`,
     * which reaches Dart as a `PlatformException`.
     *
     * The result is wrapped in a [LifecycleBoundResult] because `lifecycleScope`
     * is cancelled on `onDestroy`: without that, a host destroyed while the
     * system credential sheet is up would abandon the call and leave Dart
     * awaiting it forever.
     */
    private fun launchCredentialRequest(
        result: MethodChannel.Result,
        block: suspend () -> String,
    ) {
        val bound = LifecycleBoundResult(activity, result, ERROR_CODE)
        activity.lifecycleScope.launch {
            try {
                bound.success(block())
            } catch (e: Exception) {
                // Dart tells a dismissed sheet from a failure by the code alone.
                val code = when (e) {
                    is GetCredentialCancellationException,
                    is CreateCredentialCancellationException -> CANCELLED_CODE
                    is NoCredentialException -> NO_CREDENTIAL_CODE
                    // "RP ID cannot be validated": this package + signing certificate
                    // is not in the RP domain's assetlinks.json. A build problem, not
                    // something the user can retry.
                    is CreatePublicKeyCredentialDomException -> if (e.domError is SecurityError) RP_MISMATCH_CODE else ERROR_CODE
                    is GetPublicKeyCredentialDomException -> if (e.domError is SecurityError) RP_MISMATCH_CODE else ERROR_CODE
                    else -> ERROR_CODE
                }
                bound.error(code, e.message ?: e.toString(), e.toString())
            }
        }
    }

    companion object {
        /** Must match `PasskeyManager._channel` in `lib/src/services/passkey_manager.dart`. */
        const val CHANNEL = "com.doa.example.devicebinding.flutter/passkeys"

        private const val ERROR_CODE = "passkey_error"
        private const val CANCELLED_CODE = "passkey_cancelled"
        private const val NO_CREDENTIAL_CODE = "passkey_no_credential"
        private const val RP_MISMATCH_CODE = "passkey_rp_mismatch"

        private const val AUTHENTICATION_RESPONSE_JSON =
            "androidx.credentials.BUNDLE_KEY_AUTHENTICATION_RESPONSE_JSON"
        private const val REGISTRATION_RESPONSE_JSON =
            "androidx.credentials.BUNDLE_KEY_REGISTRATION_RESPONSE_JSON"
    }
}

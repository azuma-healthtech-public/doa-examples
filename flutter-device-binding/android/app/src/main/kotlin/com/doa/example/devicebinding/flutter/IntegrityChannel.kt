package com.doa.example.devicebinding.flutter

import android.content.Context
import com.google.android.play.core.integrity.IntegrityManagerFactory
import com.google.android.play.core.integrity.StandardIntegrityException
import com.google.android.play.core.integrity.StandardIntegrityManager.PrepareIntegrityTokenRequest
import com.google.android.play.core.integrity.StandardIntegrityManager.StandardIntegrityTokenProvider
import com.google.android.play.core.integrity.StandardIntegrityManager.StandardIntegrityTokenRequest
import com.google.android.play.core.integrity.model.StandardIntegrityErrorCode
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Play Integrity standard requests, for BSI TR-03161-1 O.Resi_2: the state of
 * the device and the app is asked of the platform (Google Play services) and
 * judged by DOA, which decodes the token with the tenant's service account.
 *
 * The token is encrypted for Google's decode endpoint, so nothing on the device
 * can read or act on the verdict. Its request hash is the server-issued
 * challenge of the request it travels with - the value DOA compares it against
 * in `GoogleDeviceAttestationHelper.ValidateIntegrity`. Tokens are never logged.
 */
class IntegrityChannel(context: Context) {
    private val manager = IntegrityManagerFactory.createStandard(context.applicationContext)
    private var provider: StandardIntegrityTokenProvider? = null
    private var providerProject: Long? = null

    fun register(messenger: BinaryMessenger): MethodChannel {
        val channel = MethodChannel(messenger, CHANNEL)
        channel.setMethodCallHandler { call, result -> handle(call, result) }
        return channel
    }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "requestToken" -> {
                val project = call.arg<String>("cloudProjectNumber").toLongOrNull()
                if (project == null) {
                    result.error(ERROR_CODE, "Invalid Google Cloud project number", null)
                    return
                }
                request(project, call.arg("requestHash"), retry = true, Once(result))
            }

            else -> result.notImplemented()
        }
    }

    /**
     * Prepares the provider once per project and reuses it - Google documents
     * preparation as the slow half. A provider can expire, which surfaces as
     * `INTEGRITY_TOKEN_PROVIDER_INVALID`; it is prepared again once, then reported.
     */
    private fun request(project: Long, requestHash: String, retry: Boolean, result: Once) {
        withProvider(project, result) { current ->
            current.request(StandardIntegrityTokenRequest.builder().setRequestHash(requestHash).build())
                .addOnSuccessListener { token -> result.success(token.token()) }
                .addOnFailureListener { e ->
                    if (retry && e is StandardIntegrityException &&
                        e.errorCode == StandardIntegrityErrorCode.INTEGRITY_TOKEN_PROVIDER_INVALID
                    ) {
                        provider = null
                        request(project, requestHash, retry = false, result)
                    } else {
                        result.fail(e)
                    }
                }
        }
    }

    private fun withProvider(
        project: Long,
        result: Once,
        block: (StandardIntegrityTokenProvider) -> Unit,
    ) {
        val cached = provider
        if (cached != null && providerProject == project) {
            block(cached)
            return
        }
        manager.prepareIntegrityToken(
            PrepareIntegrityTokenRequest.builder().setCloudProjectNumber(project).build()
        )
            .addOnSuccessListener { prepared ->
                provider = prepared
                providerProject = project
                block(prepared)
            }
            .addOnFailureListener { e -> result.fail(e) }
    }

    /** Answers a [MethodChannel.Result] exactly once; the retry path could otherwise reach it twice. */
    private class Once(private val delegate: MethodChannel.Result) {
        private var done = false

        fun success(token: String) {
            if (done) return
            done = true
            delegate.success(token)
        }

        fun fail(e: Exception) {
            if (done) return
            done = true
            // The Play error code only; exception text is not forwarded to Dart.
            delegate.error(ERROR_CODE, "Play Integrity request failed", (e as? StandardIntegrityException)?.errorCode)
        }
    }

    companion object {
        /** Must match `PlayIntegrity._channel` in `lib/src/services/play_integrity.dart`. */
        const val CHANNEL = "com.doa.example.devicebinding.flutter/integrity"

        private const val ERROR_CODE = "integrity_error"
    }
}

package com.doa.example.devicebinding.flutter

import android.content.Intent
import android.net.Uri
import android.util.Base64
import android.content.pm.ApplicationInfo
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.security.MessageDigest
import java.security.SecureRandom

/** Browser/app handoff only. OAuth exchange stays in Dart; no tokens are logged. */
class HealthIdChannel(private val activity: MainActivity) {
    private companion object {
        const val TAG = "health-id"
    }

    /** Release builds say nothing at all; this reads the manifest flag, not a
     *  build-time constant, so no extra Gradle feature has to be switched on. */
    private val debug: Boolean
        get() = activity.applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE != 0

    private var pending: MethodChannel.Result? = null
    private var redirect: Uri? = null
    fun register(messenger: BinaryMessenger) {
        MethodChannel(messenger, "com.doa.example.devicebinding.flutter/health_id")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "createProof" -> {
                        fun random(): String {
                            val bytes = ByteArray(32)
                            SecureRandom().nextBytes(bytes)
                            return Base64.encodeToString(bytes, Base64.URL_SAFE or Base64.NO_PADDING or Base64.NO_WRAP)
                        }
                        val verifier = random()
                        val challenge = Base64.encodeToString(MessageDigest.getInstance("SHA-256")
                            .digest(verifier.toByteArray(Charsets.US_ASCII)),
                            Base64.URL_SAFE or Base64.NO_PADDING or Base64.NO_WRAP)
                        result.success(mapOf("verifier" to verifier, "challenge" to challenge,
                            "state" to random(), "nonce" to random()))
                    }
                    "authorize" -> {
                        if (pending != null) {
                            result.error("BUSY", "Authentication is already running", null)
                        } else {
                            try {
                                val target = Uri.parse(call.argument<String>("url")!!)
                                val callback = Uri.parse(call.argument<String>("redirect")!!)
                                require(callback.scheme == "https" && !callback.host.isNullOrEmpty())
                                require(target.scheme !in listOf("http", "file", "intent", "javascript", "content"))
                                pending = result
                                redirect = callback
                                activity.startActivity(Intent(Intent.ACTION_VIEW, target)
                                    .addCategory(Intent.CATEGORY_BROWSABLE))
                            } catch (_: Exception) {
                                pending = null
                                redirect = null
                                result.error("UNAVAILABLE", "Could not open authenticator", null)
                            }
                        }
                    }
                    "cancel" -> { cancel(); result.success(null) }
                    else -> result.notImplemented()
                }
            }
    }
    fun handle(intent: Intent) {
        val uri = intent.data ?: return
        // Scheme, host, port and path only - never the query, which carries the
        // code and state. Debug builds only.
        if (debug) Log.d(TAG, "callback for ${uri.scheme}://${uri.host}${uri.path}")
        val expected = redirect ?: return
        if (uri.scheme != expected.scheme || uri.host != expected.host ||
            uri.port != expected.port || uri.path != expected.path) {
            if (debug) Log.d(TAG, "callback ignored, not the one awaited")
            return
        }
        val result = pending
        pending = null
        redirect = null
        result?.success(uri.toString())
    }
    fun cancel() {
        val result = pending
        pending = null
        redirect = null
        result?.error("CANCELLED", "Authentication cancelled", null)
    }
}

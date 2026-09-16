package com.doa.example.devicebinding.flutter

import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import io.flutter.plugin.common.MethodChannel

/**
 * A [MethodChannel.Result] that is completed exactly once, and that reports an
 * error if the host activity is destroyed before the call finishes.
 *
 * Both interactive channels hand their result to a callback that may never
 * fire: `BiometricPrompt` reports through `AuthenticationCallback`, and
 * `CredentialManager` runs inside `lifecycleScope`, which is cancelled on
 * destroy. An abandoned result leaves the Dart side awaiting `invokeMethod`
 * forever — the UI parks on a spinner with no error and no way out. On Android
 * that cannot be seen, because the Activity owns the UI and dies with the call;
 * in Flutter the Dart side outlives the platform side, so the stuck state is
 * real and visible.
 *
 * Completing from the lifecycle callback keeps everything on the main thread,
 * which is where a [MethodChannel.Result] must be answered.
 */
internal class LifecycleBoundResult(
    private val activity: FragmentActivity,
    private val delegate: MethodChannel.Result,
    private val errorCode: String,
) : DefaultLifecycleObserver {

    private var completed = false

    init {
        activity.lifecycle.addObserver(this)
    }

    fun success(value: Any?) = complete { delegate.success(value) }

    fun error(code: String, message: String?, details: Any?) =
        complete { delegate.error(code, message, details) }

    override fun onDestroy(owner: LifecycleOwner) {
        complete {
            delegate.error(
                errorCode,
                "The host activity was destroyed before the call completed",
                null,
            )
        }
    }

    private fun complete(block: () -> Unit) {
        if (completed) return
        completed = true
        activity.lifecycle.removeObserver(this)
        block()
    }
}

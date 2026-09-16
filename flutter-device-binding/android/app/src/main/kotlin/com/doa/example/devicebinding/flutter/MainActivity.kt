package com.doa.example.devicebinding.flutter

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import android.content.Intent
import android.os.Bundle
import android.view.WindowManager

/**
 * Host activity. Stands in for the Kotlin example's `BaseActivity`: it wires up
 * the platform channels the Dart services talk to, which is what the
 * activities there got from their base class.
 *
 * It extends [FlutterFragmentActivity], not `FlutterActivity`, because both
 * `BiometricPrompt` and `CredentialManager` require a `FragmentActivity` host.
 */
class MainActivity : FlutterFragmentActivity() {
    private val healthId = HealthIdChannel(this)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        healthId.handle(intent)
    }
    override fun onDestroy() {
        healthId.cancel()
        super.onDestroy()
    }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val messenger = flutterEngine.dartExecutor.binaryMessenger
        DeviceBindingChannel(this).register(messenger)
        BiometricBindingChannel(this).register(messenger)
        PasskeyChannel(this).register(messenger)
        IntegrityChannel(this).register(messenger)
        SecureStoreChannel(this).register(messenger)
        healthId.register(messenger)
    }
}

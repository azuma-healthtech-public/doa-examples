import Flutter
import Foundation

/// Every native channel this app exposes, created once and kept alive for the
/// life of the process. Mirrors what `MainActivity.kt` does on Android.
///
/// Two of them need to be reachable from outside the Flutter engine: the
/// Health-ID channel, because the callback arrives as a universal link on the
/// scene delegate, and the passkey channel, which needs a window to present the
/// system sheet over.
final class Channels {
  static let shared = Channels()

  let deviceBinding = DeviceBindingChannel()
  let biometrics = BiometricBindingChannel()
  let passkeys = PasskeyChannel()
  let secureStore = SecureStoreChannel()
  let healthId = HealthIdChannel()

  private var registered: [FlutterMethodChannel] = []

  private init() {}

  /// There is no Play Integrity counterpart here: on iOS the App Attest
  /// assertion in every signed request is the device-integrity evidence, so the
  /// Dart side never calls an integrity channel.
  func register(with registry: FlutterPluginRegistry) {
    guard registered.isEmpty,
          let messenger = registry.registrar(forPlugin: "DoaDeviceBinding")?.messenger()
    else { return }
    registered = [
      deviceBinding.register(with: messenger),
      biometrics.register(with: messenger),
      passkeys.register(with: messenger),
      secureStore.register(with: messenger),
      healthId.register(with: messenger),
    ]
  }
}

import Flutter
import Foundation

/// The device record's store, iOS side. Mirrors `SecureStoreChannel.kt`.
///
/// Android wraps an AES-GCM value under an RSA KeyStore key because its file
/// storage is not encrypted at rest by itself. iOS needs none of that: the
/// keychain is the encrypted store, so a value goes in directly, marked
/// `ThisDeviceOnly` so it never rides a backup to a phone whose hardware does
/// not hold the matching keys.
///
/// Reads fail closed. `CustomerStorage` treats a throw as "storage unreadable"
/// and shows the retry screen, never as "no account yet", which would silently
/// start a second registration on top of a working binding.
final class SecureStoreChannel {
  static let name = "com.doa.example.devicebinding.flutter/secure_store"

  func register(with messenger: FlutterBinaryMessenger) -> FlutterMethodChannel {
    let channel = FlutterMethodChannel(name: Self.name, binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result)
    }
    return channel
  }

  private func handle(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    do {
      switch call.method {
      case "read":
        result(try Keychain.read(try call.string("key")))
      case "write":
        try Keychain.write(try call.string("key"), try call.string("value"))
        result(nil)
      case "delete":
        try Keychain.delete(try call.string("key"))
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    } catch {
      result(FlutterError(
        code: "secure_store_error",
        message: error.localizedDescription,
        details: nil))
    }
  }
}

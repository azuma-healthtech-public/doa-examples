import CryptoKit
import DeviceCheck
import Flutter
import Foundation

/// The device key, iOS side. Mirrors `DeviceBindingChannel.kt` method for
/// method, but the primitive underneath is a different one.
///
/// Android creates an EC key in the KeyStore, proves it with an attestation
/// certificate chain, and signs each request with it. iOS has no equivalent:
/// App Attest issues a key the app never sees and cannot sign arbitrary data
/// with. What it can do is *attest* the key once against a challenge, and
/// afterwards produce *assertions* over a client-data hash. So:
///
/// * `generateECKeyPair` creates the App Attest key and attests it against the
///   registration challenge, keeping both the key id and the attestation.
/// * `getDeviceAttestationsKey` hands back that attestation, which DOA verifies
///   with Apple's root and the tenant's team and bundle id.
/// * `sign` returns a CBOR assertion, which is what DOA verifies on iOS instead
///   of an ECDSA signature, and which doubles as the per-request integrity
///   evidence - there is no Play Integrity counterpart to send.
///
/// The key id is kept in the keychain under the caller's identifier, because
/// `attestKey` may be called only once per key: losing the id would strand the
/// binding with no way to sign for it again.
final class DeviceBindingChannel {
  static let name = "com.doa.example.devicebinding.flutter/device_binding"

  private let service = DCAppAttestService.shared

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
      case "initializeKeyStore":
        // Nothing to open on iOS; the keychain and App Attest are always there.
        // The call stays so both platforms start the same way.
        guard service.isSupported else {
          throw ChannelError.unsupported(
            "App Attest is not available on this device")
        }
        result(nil)

      case "generateECKeyPair":
        let identifier = try call.string("identifier")
        let challenge = try call.string("challenge")
        generate(identifier: identifier, challenge: challenge, result: result)

      case "getDeviceAttestationsKey":
        let identifier = try call.string("identifier")
        guard let attestation = try Keychain.read(Self.attestationAccount(identifier)) else {
          throw ChannelError.failed("No attestation for '\(identifier)'")
        }
        result(attestation)

      case "getHardwareKeyId":
        result(try Keychain.read(Self.keyAccount(try call.string("identifier"))))

      case "sign":
        let identifier = try call.string("identifier")
        let data = try call.string("data")
        sign(identifier: identifier, data: data, result: result)

      case "reset":
        let identifier = try call.string("identifier")
        // The App Attest key itself cannot be deleted by the app. Dropping the
        // id orphans it, which is what the Android side does with its alias.
        try Keychain.delete(Self.keyAccount(identifier))
        try Keychain.delete(Self.attestationAccount(identifier))
        result(nil)

      default:
        result(FlutterMethodNotImplemented)
      }
    } catch {
      result(Self.error(error))
    }
  }

  private func generate(
    identifier: String, challenge: String, result: @escaping FlutterResult
  ) {
    guard service.isSupported else {
      result(Self.error(ChannelError.unsupported(
        "App Attest is not available on this device")))
      return
    }
    service.generateKey { [weak self] keyId, error in
      guard let self else { return }
      if let error { result(Self.error(error)); return }
      guard let keyId else {
        result(Self.error(ChannelError.failed("App Attest returned no key")))
        return
      }
      let hash = Data(SHA256.hash(data: Data(challenge.utf8)))
      self.service.attestKey(keyId, clientDataHash: hash) { attestation, error in
        if let error { result(Self.error(error)); return }
        guard let attestation else {
          result(Self.error(ChannelError.failed("App Attest returned no attestation")))
          return
        }
        do {
          // Both or neither: an id without its attestation cannot be registered,
          // and an attestation without its id cannot be used again.
          try Keychain.write(Self.keyAccount(identifier), keyId)
          try Keychain.write(
            Self.attestationAccount(identifier), attestation.base64EncodedString())
          result(nil)
        } catch {
          result(Self.error(error))
        }
      }
    }
  }

  private func sign(
    identifier: String, data: String, result: @escaping FlutterResult
  ) {
    do {
      guard let keyId = try Keychain.read(Self.keyAccount(identifier)) else {
        throw ChannelError.failed("No device key for '\(identifier)'")
      }
      let hash = Data(SHA256.hash(data: Data(data.utf8)))
      service.generateAssertion(keyId, clientDataHash: hash) { assertion, error in
        if let error { result(Self.error(error)); return }
        guard let assertion else {
          result(Self.error(ChannelError.failed("App Attest returned no assertion")))
          return
        }
        result(assertion.base64EncodedString())
      }
    } catch {
      result(Self.error(error))
    }
  }

  private static func keyAccount(_ identifier: String) -> String {
    "deviceKey.\(identifier)"
  }

  private static func attestationAccount(_ identifier: String) -> String {
    "deviceAttestation.\(identifier)"
  }

  /// One error shape for the whole channel. The message reaches Dart but never
  /// the user: `CustomerController.run` maps it to fixed text.
  static func error(_ error: Error) -> FlutterError {
    FlutterError(
      code: "device_binding_error",
      message: error.localizedDescription,
      details: nil)
  }
}

import Flutter
import Foundation
import LocalAuthentication
import Security

/// The biometric key, iOS side. Mirrors `BiometricBindingChannel.kt`.
///
/// A P-256 key in the Secure Enclave, created with `.biometryCurrentSet` so it
/// is destroyed the moment the enrolled biometrics change - the same property
/// `setInvalidatedByBiometricEnrollment` gives the Android key, and the reason
/// the app can treat a failing key as "set this up again" rather than as a
/// transient error. `.privateKeyUsage` means every single use prompts; there is
/// no unlocked window.
///
/// Two encodings matter, because DOA verifies both with .NET:
/// * the public key travels as SubjectPublicKeyInfo, while the Secure Enclave
///   hands out a raw X9.63 point, so the ASN.1 header is added here;
/// * the signature travels as a DER sequence, which is what
///   `.ecdsaSignatureMessageX962SHA256` already produces.
///
/// There is no iOS counterpart to Android key attestation, so no attestation
/// accompanies the key. DOA treats it as absent (attestation is measured on Android
/// first), and the Dart layer sends the link without that field.
final class BiometricBindingChannel {
  static let name = "com.doa.example.devicebinding.flutter/biometric_binding"

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
      case "canAuthenticate":
        var error: NSError?
        let ok = LAContext().canEvaluatePolicy(
          .deviceOwnerAuthenticationWithBiometrics, error: &error)
        result(ok)

      case "generateBiometricKey":
        let alias = try call.string("alias")
        // The Secure Enclave is P-256 only. The customer journey asks for
        // exactly that; anything else is a configuration mistake, not a
        // fallback, so it fails loudly instead of silently using software keys.
        if let algorithm = call.optionalString("algorithm"),
           algorithm.lowercased().contains("rsa") {
          throw ChannelError.unsupported(
            "The Secure Enclave holds P-256 keys only; RSA is not available")
        }
        let publicKey = try generateKey(alias: alias)
        // No attestation on iOS: the map keeps the shape the Dart side reads.
        result(["publicKey": publicKey])

      case "signChallenge":
        let alias = try call.string("alias")
        let challenge = try call.string("challenge")
        let title = call.optionalString("promptTitle") ?? "Confirm it's you"
        sign(alias: alias, challenge: challenge, reason: title, result: result)

      case "reset":
        try deleteKey(alias: try call.string("alias"))
        result(nil)

      default:
        result(FlutterMethodNotImplemented)
      }
    } catch {
      result(Self.error(error))
    }
  }

  // MARK: - key material

  private func generateKey(alias: String) throws -> String {
    try deleteKey(alias: alias)

    var accessError: Unmanaged<CFError>?
    guard let access = SecAccessControlCreateWithFlags(
      kCFAllocatorDefault,
      // Requires a passcode to be set, and never leaves this device.
      kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
      [.privateKeyUsage, .biometryCurrentSet],
      &accessError)
    else {
      throw ChannelError.failed(Self.describe(accessError))
    }

    let attributes: [String: Any] = [
      kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
      kSecAttrKeySizeInBits as String: 256,
      kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
      kSecPrivateKeyAttrs as String: [
        kSecAttrIsPermanent as String: true,
        kSecAttrApplicationTag as String: Self.tag(alias),
        kSecAttrAccessControl as String: access,
      ],
    ]

    var createError: Unmanaged<CFError>?
    guard let privateKey = SecKeyCreateRandomKey(
      attributes as CFDictionary, &createError)
    else {
      throw ChannelError.failed(Self.describe(createError))
    }
    guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
      throw ChannelError.failed("The key has no public half")
    }
    var exportError: Unmanaged<CFError>?
    guard let raw = SecKeyCopyExternalRepresentation(publicKey, &exportError) as Data?
    else {
      throw ChannelError.failed(Self.describe(exportError))
    }
    return Self.subjectPublicKeyInfo(fromX963: raw).base64EncodedString()
  }

  private func sign(
    alias: String, challenge: String, reason: String,
    result: @escaping FlutterResult
  ) {
    // The prompt is the Secure Enclave's own, raised by the key's access
    // control when it is used. The context carries the reason string and is
    // never reused, so one prompt covers exactly one signature.
    let context = LAContext()
    context.localizedReason = reason
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        guard let key = try Self.privateKey(alias: alias, context: context) else {
          throw ChannelError.failed("No biometric key for '\(alias)'")
        }
        var error: Unmanaged<CFError>?
        guard let signature = SecKeyCreateSignature(
          key,
          .ecdsaSignatureMessageX962SHA256,
          Data(challenge.utf8) as CFData,
          &error) as Data?
        else {
          throw ChannelError.failed(Self.describe(error))
        }
        DispatchQueue.main.async { result(signature.base64EncodedString()) }
      } catch {
        DispatchQueue.main.async { result(Self.error(error)) }
      }
    }
  }

  private func deleteKey(alias: String) throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassKey,
      kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
      kSecAttrApplicationTag as String: Self.tag(alias),
    ]
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw Keychain.Failure.status(status)
    }
  }

  private static func privateKey(alias: String, context: LAContext) throws -> SecKey? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassKey,
      kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
      kSecAttrApplicationTag as String: tag(alias),
      kSecReturnRef as String: true,
      kSecUseAuthenticationContext as String: context,
    ]
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    if status == errSecItemNotFound { return nil }
    guard status == errSecSuccess else { throw Keychain.Failure.status(status) }
    return (item as! SecKey)
  }

  private static func tag(_ alias: String) -> Data {
    Data("\(Keychain.service).biometric.\(alias)".utf8)
  }

  /// Wraps a raw P-256 point (`04 || X || Y`) in the SubjectPublicKeyInfo DER
  /// that .NET's `ImportSubjectPublicKeyInfo` reads. The header is constant for
  /// prime256v1, so it is written out rather than assembled with an ASN.1
  /// encoder that iOS does not ship.
  static func subjectPublicKeyInfo(fromX963 raw: Data) -> Data {
    let header: [UInt8] = [
      0x30, 0x59,                                            // SEQUENCE, 89 bytes
      0x30, 0x13,                                            // SEQUENCE, 19 bytes
      0x06, 0x07, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x02, 0x01,  // OID ecPublicKey
      0x06, 0x08, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x03, 0x01, 0x07,  // OID prime256v1
      0x03, 0x42, 0x00,                                      // BIT STRING, 66 bytes
    ]
    return Data(header) + raw
  }

  private static func describe(_ error: Unmanaged<CFError>?) -> String {
    guard let error else { return "Key operation failed" }
    return (error.takeRetainedValue() as Error).localizedDescription
  }

  /// Cancellation has its own code so Dart can tell "the user stopped" from
  /// "the phone refused", which is the difference between an info notice and an
  /// error banner.
  static func error(_ error: Error) -> FlutterError {
    let code: String
    switch (error as NSError).code {
    case Int(errSecUserCanceled), LAError.userCancel.rawValue,
         LAError.systemCancel.rawValue, LAError.appCancel.rawValue:
      code = "CANCELLED"
    default:
      code = "biometric_binding_error"
    }
    return FlutterError(
      code: code, message: error.localizedDescription, details: nil)
  }
}

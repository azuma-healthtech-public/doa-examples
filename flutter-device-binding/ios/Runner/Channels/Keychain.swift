import Foundation

/// The one place this app talks to the keychain.
///
/// Everything stored here is `ThisDeviceOnly`: it must never travel to another
/// phone through an encrypted backup or a device transfer, because every value
/// identifies a binding that only this phone's hardware keys can honour. A
/// restored copy would point at keys that are not there.
enum Keychain {
  static let service = "com.doa.example.devicebinding.flutter"

  enum Failure: Error {
    case status(OSStatus)
  }

  static func read(_ account: String) throws -> String? {
    var query = base(account)
    query[kSecReturnData as String] = true
    query[kSecMatchLimit as String] = kSecMatchLimitOne

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    if status == errSecItemNotFound { return nil }
    guard status == errSecSuccess else { throw Failure.status(status) }
    guard let data = item as? Data else { return nil }
    return String(data: data, encoding: .utf8)
  }

  /// Replaces rather than merges: a second write for the same account is a new
  /// binding, and half of an old one is worse than none.
  static func write(_ account: String, _ value: String) throws {
    try delete(account)
    var query = base(account)
    query[kSecValueData as String] = Data(value.utf8)
    query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    let status = SecItemAdd(query as CFDictionary, nil)
    guard status == errSecSuccess else { throw Failure.status(status) }
  }

  static func delete(_ account: String) throws {
    let status = SecItemDelete(base(account) as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw Failure.status(status)
    }
  }

  private static func base(_ account: String) -> [String: Any] {
    [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
    ]
  }
}

extension FlutterMethodCall {
  /// Reads a required string argument, or throws so the handler can answer with
  /// one shared error shape instead of each method inventing its own.
  func string(_ name: String) throws -> String {
    guard let args = arguments as? [String: Any],
          let value = args[name] as? String
    else { throw ChannelError.missingArgument(name) }
    return value
  }

  func optionalString(_ name: String) -> String? {
    (arguments as? [String: Any])?[name] as? String
  }
}

enum ChannelError: Error, LocalizedError {
  case missingArgument(String)
  case unsupported(String)
  case failed(String)

  var errorDescription: String? {
    switch self {
    case .missingArgument(let name): return "Missing argument '\(name)'"
    case .unsupported(let what): return what
    case .failed(let what): return what
    }
  }
}

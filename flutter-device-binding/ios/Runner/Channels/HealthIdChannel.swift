import CryptoKit
import Flutter
import Foundation
import UIKit

/// The Health-ID hand-off, iOS side. Mirrors `HealthIdChannel.kt`.
///
/// The same shape as Android on purpose: the proof is made here so the verifier
/// never crosses into Dart before it is needed, the insurer's page opens in the
/// system browser rather than an in-app web view, and the call stays pending
/// until the universal link comes back. The callback is matched on scheme,
/// host, port and path against the registered redirect, and anything else is
/// ignored rather than answered - a foreign link must not complete someone's
/// sign-in.
///
/// Safari is used rather than `ASWebAuthenticationSession` because the redirect
/// is an https universal link, which that API can only capture from iOS 17.4.
/// Opening the browser and receiving the link through the app is what Android
/// does and works on every supported version.
final class HealthIdChannel {
  static let name = "com.doa.example.devicebinding.flutter/health_id"

  private var pending: FlutterResult?
  private var expectedRedirect: URLComponents?

  func register(with messenger: FlutterBinaryMessenger) -> FlutterMethodChannel {
    let channel = FlutterMethodChannel(name: Self.name, binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result)
    }
    return channel
  }

  private func handle(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    switch call.method {
    case "createProof":
      let verifier = Self.random()
      let challenge = Data(SHA256.hash(data: Data(verifier.utf8))).base64URLEncoded
      result([
        "verifier": verifier,
        "challenge": challenge,
        "state": Self.random(),
        "nonce": Self.random(),
      ])

    case "authorize":
      guard pending == nil else {
        result(FlutterError(
          code: "BUSY", message: "Authentication is already running", details: nil))
        return
      }
      guard let raw = call.optionalString("url"),
            let url = URL(string: raw),
            let redirect = call.optionalString("redirect"),
            let expected = URLComponents(string: redirect)
      else {
        result(FlutterError(
          code: "UNAVAILABLE", message: "Could not open authenticator", details: nil))
        return
      }
      pending = result
      expectedRedirect = expected
      UIApplication.shared.open(url, options: [:]) { [weak self] opened in
        guard let self, !opened else { return }
        self.finish(FlutterError(
          code: "UNAVAILABLE", message: "Could not open authenticator", details: nil))
      }

    case "cancel":
      finish(FlutterError(
        code: "CANCELLED", message: "Authentication cancelled", details: nil))
      result(nil)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Called by the app delegate for every universal link. Returns true only
  /// when this was the callback being waited for, so the rest of the app can
  /// go on handling its own links.
  @discardableResult
  func handle(callback url: URL) -> Bool {
    guard pending != nil,
          let expected = expectedRedirect,
          let incoming = URLComponents(url: url, resolvingAgainstBaseURL: false),
          incoming.scheme == expected.scheme,
          incoming.host == expected.host,
          incoming.port == expected.port,
          incoming.path == expected.path
    else { return false }
    finish(url.absoluteString)
    return true
  }

  /// A process death or a dismissed browser leaves nothing pending to resume;
  /// the Dart side times the flow out and starts the next one with fresh proof.
  private func finish(_ value: Any?) {
    let result = pending
    pending = nil
    expectedRedirect = nil
    result?(value)
  }

  /// 32 bytes from the system CSPRNG, base64url without padding: a PKCE
  /// verifier, and the same source for `state` and `nonce`.
  private static func random() -> String {
    var bytes = [UInt8](repeating: 0, count: 32)
    let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
    precondition(status == errSecSuccess, "The system CSPRNG failed")
    return Data(bytes).base64URLEncoded
  }
}

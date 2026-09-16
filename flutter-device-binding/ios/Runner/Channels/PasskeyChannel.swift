import AuthenticationServices
import Flutter
import Foundation
import UIKit

/// Passkeys, iOS side. Mirrors `PasskeyChannel.kt`.
///
/// Android's Credential Manager speaks WebAuthn JSON, so the Kotlin channel can
/// hand the server's options straight through and give the response back
/// untouched. `AuthenticationServices` does not: it takes decoded fields and
/// returns decoded fields, so this channel parses exactly what the request
/// needs and rebuilds exactly the JSON the relying party expects. The values
/// themselves are copied, never re-derived - the challenge that goes to the
/// authenticator is the server's own bytes, and the client data that comes back
/// is forwarded verbatim.
///
/// The relying party is whatever `rp.id` the server sent. iOS will only honour
/// it when the app carries `webcredentials:<that domain>` in its Associated
/// Domains entitlement and the domain serves a matching
/// `apple-app-site-association`.
final class PasskeyChannel: NSObject {
  static let name = "com.doa.example.devicebinding.flutter/passkeys"

  private var pending: FlutterResult?

  func register(with messenger: FlutterBinaryMessenger) -> FlutterMethodChannel {
    let channel = FlutterMethodChannel(name: Self.name, binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result)
    }
    return channel
  }

  private func handle(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    guard #available(iOS 15.0, *) else {
      result(Self.failure("Passkeys need iOS 15 or later"))
      return
    }
    guard pending == nil else {
      result(FlutterError(
        code: "BUSY", message: "A passkey request is already running", details: nil))
      return
    }
    do {
      let json = try call.string("requestJson")
      switch call.method {
      case "createCredential":
        pending = result
        try create(options: try Self.object(from: json))
      case "getCredential":
        pending = result
        try assert(options: try Self.object(from: json))
      default:
        result(FlutterMethodNotImplemented)
      }
    } catch {
      pending = nil
      result(Self.failure(error.localizedDescription))
    }
  }

  // MARK: - requests

  @available(iOS 15.0, *)
  private func create(options: [String: Any]) throws {
    // Options may arrive wrapped in `publicKey`, as the WebAuthn JSON does.
    let root = (options["publicKey"] as? [String: Any]) ?? options
    guard let rp = root["rp"] as? [String: Any],
          let rpId = rp["id"] as? String,
          let user = root["user"] as? [String: Any],
          let userName = user["name"] as? String,
          let userId = (user["id"] as? String)?.base64URLDecoded,
          let challenge = (root["challenge"] as? String)?.base64URLDecoded
    else { throw ChannelError.failed("Incomplete registration options") }

    let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(
      relyingPartyIdentifier: rpId)
    let request = provider.createCredentialRegistrationRequest(
      challenge: challenge, name: userName, userID: userId)
    start(request)
  }

  @available(iOS 15.0, *)
  private func assert(options: [String: Any]) throws {
    let root = (options["publicKey"] as? [String: Any]) ?? options
    guard let rpId = root["rpId"] as? String,
          let challenge = (root["challenge"] as? String)?.base64URLDecoded
    else { throw ChannelError.failed("Incomplete sign-in options") }

    let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(
      relyingPartyIdentifier: rpId)
    let request = provider.createCredentialAssertionRequest(challenge: challenge)
    if let allowed = root["allowCredentials"] as? [[String: Any]] {
      request.allowedCredentials = allowed.compactMap { entry in
        guard let id = (entry["id"] as? String)?.base64URLDecoded else { return nil }
        return ASAuthorizationPlatformPublicKeyCredentialDescriptor(
          credentialID: id)
      }
    }
    start(request)
  }

  private func start(_ request: ASAuthorizationRequest) {
    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
  }

  // MARK: - helpers

  private static func object(from json: String) throws -> [String: Any] {
    guard let data = json.data(using: .utf8),
          let parsed = try JSONSerialization.jsonObject(with: data) as? [String: Any]
    else { throw ChannelError.failed("The server's options are not an object") }
    return parsed
  }

  private static func encode(_ value: [String: Any]) throws -> String {
    let data = try JSONSerialization.data(withJSONObject: value)
    guard let text = String(data: data, encoding: .utf8) else {
      throw ChannelError.failed("The response could not be encoded")
    }
    return text
  }

  private static func failure(_ message: String) -> FlutterError {
    FlutterError(code: "passkey_error", message: message, details: nil)
  }

  fileprivate func finish(_ value: Any?) {
    let result = pending
    pending = nil
    result?(value)
  }
}

// MARK: - authorisation callbacks

extension PasskeyChannel: ASAuthorizationControllerDelegate {
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    guard #available(iOS 15.0, *) else { return }
    do {
      if let registration = authorization.credential
        as? ASAuthorizationPlatformPublicKeyCredentialRegistration {
        let id = registration.credentialID.base64URLEncoded
        finish(try Self.encode([
          "id": id,
          "rawId": id,
          "type": "public-key",
          "response": [
            "clientDataJSON": registration.rawClientDataJSON.base64URLEncoded,
            "attestationObject":
              registration.rawAttestationObject?.base64URLEncoded ?? "",
          ],
        ]))
      } else if let assertion = authorization.credential
        as? ASAuthorizationPlatformPublicKeyCredentialAssertion {
        let id = assertion.credentialID.base64URLEncoded
        var response: [String: Any] = [
          "clientDataJSON": assertion.rawClientDataJSON.base64URLEncoded,
          "authenticatorData": assertion.rawAuthenticatorData.base64URLEncoded,
          "signature": assertion.signature.base64URLEncoded,
        ]
        if let handle = assertion.userID {
          response["userHandle"] = handle.base64URLEncoded
        }
        finish(try Self.encode([
          "id": id,
          "rawId": id,
          "type": "public-key",
          "response": response,
        ]))
      } else {
        finish(Self.failure("Unexpected credential type"))
      }
    } catch {
      finish(Self.failure(error.localizedDescription))
    }
  }

  func authorizationController(
    controller: ASAuthorizationController, didCompleteWithError error: Error
  ) {
    let code: String
    switch (error as? ASAuthorizationError)?.code {
    case .canceled:
      // The sheet was dismissed. Not a failure: the app says so in info tone.
      code = "passkey_cancelled"
    case .failed, .invalidResponse, .notHandled, .notInteractive:
      // The usual cause is an app whose Associated Domains entitlement or
      // published association file does not cover the relying party.
      code = "passkey_rp_mismatch"
    default:
      code = "passkey_error"
    }
    finish(FlutterError(
      code: code, message: error.localizedDescription, details: nil))
  }
}

extension PasskeyChannel: ASAuthorizationControllerPresentationContextProviding {
  /// The sheet is presented over whichever window is in front. Looked up now
  /// rather than held, because a scene can be replaced while the app runs.
  func presentationAnchor(
    for controller: ASAuthorizationController
  ) -> ASPresentationAnchor {
    let window = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap(\.windows)
      .first { $0.isKeyWindow }
    return window ?? ASPresentationAnchor()
  }
}

// MARK: - base64url

extension Data {
  var base64URLEncoded: String {
    base64EncodedString()
      .replacingOccurrences(of: "+", with: "-")
      .replacingOccurrences(of: "/", with: "_")
      .replacingOccurrences(of: "=", with: "")
  }
}

extension String {
  var base64URLDecoded: Data? {
    var text = replacingOccurrences(of: "-", with: "+")
      .replacingOccurrences(of: "_", with: "/")
    if text.count % 4 != 0 {
      text.append(String(repeating: "=", count: 4 - text.count % 4))
    }
    return Data(base64Encoded: text)
  }
}

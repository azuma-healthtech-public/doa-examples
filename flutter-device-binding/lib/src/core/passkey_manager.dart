import 'package:flutter/services.dart';

import 'platform_channel.dart';

/// Dart face of the `androidx.credentials` calls the Kotlin activities make
/// inline (`CredentialManager.getCredential` / `createCredential`).
///
/// The server hands us the WebAuthn options as an opaque JSON string and wants
/// the response JSON back verbatim, so this channel passes both through
/// untouched. That is also why there is no passkey pub package here: the ones
/// on pub.dev model the options as typed objects and would re-serialise them,
/// which is exactly what the "keep the original payload" contract forbids.
class PasskeyManager {
  const PasskeyManager();

  /// Must match `PasskeyChannel.CHANNEL` in
  /// `android/app/src/main/kotlin/com/azuma/example/devicebinding/PasskeyChannel.kt`.
  static const MethodChannel _channel = MethodChannel(
    'com.doa.example.devicebinding.flutter/passkeys',
  );

  /// `GetCredentialRequest(GetPublicKeyCredentialOption(...))` — returns the
  /// authentication response JSON (`BUNDLE_KEY_AUTHENTICATION_RESPONSE_JSON`).
  Future<String> getCredential(String requestJson) async {
    // Interactive: this call blocks on the Credential Manager sheet.
    final assertion = await _channel
        .invokeMethod<String>('getCredential', {'requestJson': requestJson})
        .bounded('getCredential', kInteractiveChannelTimeout);
    if (assertion == null) {
      throw StateError(
        'Failed to get assertion response from Credential Manager',
      );
    }
    return assertion;
  }

  /// `CreatePublicKeyCredentialRequest(...)` — returns the registration
  /// response JSON (`BUNDLE_KEY_REGISTRATION_RESPONSE_JSON`).
  Future<String> createCredential(String requestJson) async {
    // Interactive: this call blocks on the Credential Manager sheet.
    final attestation = await _channel
        .invokeMethod<String>('createCredential', {'requestJson': requestJson})
        .bounded('createCredential', kInteractiveChannelTimeout);
    if (attestation == null) {
      throw StateError('Failed to get registration response');
    }
    return attestation;
  }
}

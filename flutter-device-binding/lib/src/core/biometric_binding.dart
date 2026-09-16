import 'package:flutter/services.dart';

import 'device_os.dart';
import 'platform_channel.dart';

/// Which key the biometric-gated credential uses. Mirrors
/// `BiometricBinding.Algorithm` in the Kotlin example — the doa backend accepts
/// both on `/api/biometric/link` and `/api/biometric/login`.
enum BiometricAlgorithm {
  /// EC P-256 (ES256) — the default, and the WebAuthn/FIDO2 default.
  ecP256('EC_P256'),

  /// RSA-3072 (RSASSA-PKCS1-v1_5 + SHA-256) — parity with libraries that don't
  /// expose EC, and still above the server's 2048-bit floor.
  rsa3072('RSA_3072');

  const BiometricAlgorithm(this.wireName);

  /// The name the Kotlin side parses back into its own enum.
  final String wireName;
}

/// A biometric key generated with a server challenge: its public key as base64
/// SubjectPublicKeyInfo (`DeviceBindingBiometricsLinkRequest.publicKey`) and
/// the AndroidKeyStore attestation chain over that challenge, in the same
/// encoding as `DeviceAttestationDto.attestation`.
class AttestedBiometricKey {
  const AttestedBiometricKey({required this.publicKey, this.attestation});

  final String publicKey;

  /// The certificate chain proving the key lives in secure hardware and demands
  /// a biometric per use. Android only: iOS has no attestation for a Secure
  /// Enclave key, so it is absent there and the link omits the field.
  final String? attestation;
}

/// Dart face of `services/BiometricBinding.kt`.
///
/// `BiometricPrompt` has to hold the `Signature` object it authorises, so the
/// prompt and the signing step are a single native call — `local_auth` and
/// friends cannot express that binding, which is why this goes over a
/// [MethodChannel] rather than a pub package.
class BiometricBinding {
  const BiometricBinding();

  /// Must match `BiometricBindingChannel.CHANNEL` in
  /// `android/app/src/main/kotlin/com/azuma/example/devicebinding/BiometricBindingChannel.kt`.
  static const MethodChannel _channel = MethodChannel(
    'com.doa.example.devicebinding.flutter/biometric_binding',
  );

  /// `BiometricManager.canAuthenticate(BIOMETRIC_STRONG) == BIOMETRIC_SUCCESS`.
  ///
  /// The dashboard checks this before linking so it never creates a key the
  /// device cannot unlock.
  Future<bool> canAuthenticate() async {
    final result = await _channel
        .invokeMethod<bool>('canAuthenticate')
        .bounded('canAuthenticate', kChannelTimeout);
    return result ?? false;
  }

  /// Creates the biometric-gated key under [alias] and returns its public key
  /// as base64 SubjectPublicKeyInfo — the value for
  /// `DeviceBindingBiometricsLinkRequest.publicKey`.
  ///
  /// No attestation: this is the legacy demo's path, a 1:1 port of the Kotlin
  /// sample. The customer journey uses [generateAttestedBiometricKey].
  Future<String> generateBiometricKey(
    String alias, {
    BiometricAlgorithm algorithm = BiometricAlgorithm.ecP256,
  }) async {
    final material = await _generate(alias, algorithm, challenge: null);
    return material['publicKey']!;
  }

  /// Creates the biometric-gated key under [alias] with [challenge] as its
  /// attestation challenge, and returns the public key together with the
  /// attestation chain. The chain lets the server verify that the key lives in
  /// secure hardware and demands a biometric on every use (DOA does not read it yet).
  Future<AttestedBiometricKey> generateAttestedBiometricKey({
    required String alias,
    required String challenge,
    BiometricAlgorithm algorithm = BiometricAlgorithm.ecP256,
  }) async {
    final material = await _generate(alias, algorithm, challenge: challenge);
    // Android must produce one - a missing chain there means the key is not
    // where it claims to be. iOS has no equivalent and returns none.
    final attestation = material['attestation'];
    if (attestation == null && !DeviceOs.isIos) {
      throw StateError('Biometric key generation returned no attestation');
    }
    return AttestedBiometricKey(
      publicKey: material['publicKey']!,
      attestation: attestation,
    );
  }

  Future<Map<String, String>> _generate(
    String alias,
    BiometricAlgorithm algorithm, {
    required String? challenge,
  }) async {
    final material = await _channel
        .invokeMapMethod<String, String>('generateBiometricKey', {
          'alias': alias,
          'algorithm': algorithm.wireName,
          'challenge': ?challenge,
        })
        .bounded('generateBiometricKey', kChannelTimeout);
    if (material == null || material['publicKey'] == null) {
      throw StateError('Biometric key generation returned no public key');
    }
    return material;
  }

  /// Signs UTF-8([challenge]) with the key under [alias], prompting the user.
  /// Returns the base64 signature — the value for `requestSignature`.
  Future<String> signChallenge({
    required String alias,
    required String challenge,
    String promptTitle = 'Sign in',
    String promptSubtitle = 'Use biometrics to authenticate this request',
  }) async {
    // Interactive: this call blocks on the user answering BiometricPrompt.
    final signature = await _channel
        .invokeMethod<String>('signChallenge', {
          'alias': alias,
          'challenge': challenge,
          'promptTitle': promptTitle,
          'promptSubtitle': promptSubtitle,
        })
        .bounded('signChallenge', kInteractiveChannelTimeout);
    if (signature == null) {
      throw StateError('Biometric signing returned no signature');
    }
    return signature;
  }

  /// Drops the biometric key under [alias].
  Future<void> reset(String alias) async {
    await _channel
        .invokeMethod<void>('reset', {'alias': alias})
        .bounded('reset', kChannelTimeout);
  }
}

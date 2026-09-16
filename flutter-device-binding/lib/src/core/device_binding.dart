import 'package:doa_device_binding_api/doa_device_binding_api.dart';
import 'package:flutter/services.dart';

import 'device_os.dart';
import 'platform_channel.dart';

/// Dart face of `services/DeviceBinding.kt`.
///
/// Hardware-backed key material cannot leave the platform, so the KeyStore work
/// itself still runs in Kotlin — see
/// `android/app/src/main/kotlin/com/azuma/example/devicebinding/DeviceBindingChannel.kt`.
/// This class is the [MethodChannel] wrapper; the method names below map
/// one-for-one onto the Kotlin functions of the same name.
class DeviceBinding {
  const DeviceBinding();

  /// Must match `DeviceBindingChannel.CHANNEL` in
  /// `android/app/src/main/kotlin/com/azuma/example/devicebinding/DeviceBindingChannel.kt`.
  /// The two halves cannot share a constant across the language boundary, so a
  /// mismatch shows up only at runtime, as a `MissingPluginException`.
  static const MethodChannel _channel = MethodChannel(
    'com.doa.example.devicebinding.flutter/device_binding',
  );

  /// `ks.load(null)`. Called once at startup, as `BaseActivity.setupKeystore` does.
  Future<void> initializeKeyStore() async {
    await _channel
        .invokeMethod<void>('initializeKeyStore')
        .bounded('initializeKeyStore', kChannelTimeout);
  }

  /// Creates the device key for [identifier], bound to [challenge].
  ///
  /// Android: a P-256 KeyStore key with the challenge baked in as its
  /// attestation challenge. iOS: an App Attest key, attested against the same
  /// challenge. Either way the challenge is what ties the key to this request.
  /// [biometricGated] is variant C's phone-key profile: the device key itself
  /// demands a strong biometric, dies when enrolment changes, and stays usable
  /// for ten minutes after one authentication - one prompt per session,
  /// enforced by the secure hardware rather than by the UI. Android only; the
  /// iOS device key is an App Attest key, which cannot carry that requirement.
  Future<void> generateEcKeyPair({
    required String identifier,
    required String challenge,
    bool biometricGated = false,
  }) async {
    await _channel
        .invokeMethod<void>('generateECKeyPair', {
          'identifier': identifier,
          'challenge': challenge,
          'biometricGated': biometricGated,
        })
        .bounded('generateECKeyPair', kChannelTimeout);
  }

  /// The device's attestation certificate chain, ready for the register call.
  ///
  /// Kotlin returns a `DeviceAttestationDto`; the channel hands back just the
  /// encoded chain and the DTO is assembled here, so the generated model stays
  /// on the Dart side of the boundary.
  Future<DeviceAttestationDto> getDeviceAttestationsKey(String identifier) async {
    final attestation = await _channel
        .invokeMethod<String>('getDeviceAttestationsKey', {
          'identifier': identifier,
        })
        .bounded('getDeviceAttestationsKey', kChannelTimeout);
    return DeviceAttestationDto(
      attestation: attestation,
      deviceName: 'Mobile',
      deviceOs: DeviceOs.model,
    );
  }

  /// The App Attest key id for [identifier], which iOS sends alongside the
  /// attestation so DOA can bind the two. Null on Android, where the key is
  /// identified by the attestation chain itself.
  Future<String?> hardwareKeyId(String identifier) async {
    if (!DeviceOs.isIos) return null;
    return _channel
        .invokeMethod<String>('getHardwareKeyId', {'identifier': identifier})
        .bounded('getHardwareKeyId', kChannelTimeout);
  }

  /// Proves [data] with the device key bound to [identifier], base64 encoded.
  ///
  /// Android returns a `SHA256withECDSA` signature. iOS returns a CBOR App
  /// Attest assertion over the same bytes, which is what DOA verifies there and
  /// what doubles as the device-integrity proof on every request.
  Future<String> sign(String data, String identifier) async {
    final signature = await _channel
        .invokeMethod<String>('sign', {'data': data, 'identifier': identifier})
        .bounded('sign', kChannelTimeout);
    if (signature == null) {
      throw StateError('Signature generation returned null for "$identifier"');
    }
    return signature;
  }

  /// Runs the biometric prompt on its own, without signing anything. Variant C
  /// calls it at every session start.
  ///
  /// A time-bound key counts *any* strong-biometric authentication inside its
  /// window - unlocking the phone with a finger included - so left to the
  /// hardware alone, a sign-in shortly after unlocking the phone asks nothing.
  /// The key stays gated underneath: this prompt is what the session promises,
  /// the keystore is what refuses without a biometric in the window. Android
  /// only; iOS never reaches the phone-key journey.
  Future<void> unlock() async {
    // Interactive: this call blocks on the user answering the prompt.
    await _channel
        .invokeMethod<void>('unlock')
        .bounded('unlock', kInteractiveChannelTimeout);
  }

  /// Drops the device key for [identifier].
  Future<void> reset(String identifier) async {
    await _channel
        .invokeMethod<void>('reset', {'identifier': identifier})
        .bounded('reset', kChannelTimeout);
  }
}

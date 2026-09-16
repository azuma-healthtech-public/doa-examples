import 'dart:io' show Platform;

import 'package:doa_device_binding_api/doa_device_binding_api.dart';

/// The two platforms this example binds a device on, and the shape each one's
/// proof takes. DOA branches on the `deviceOs` of every signed request, and the
/// two branches are not symmetric:
///
/// * **Android** signs the request payload with a KeyStore EC key, proves that
///   key with an attestation certificate chain, and carries a separate Play
///   Integrity token for device integrity.
/// * **iOS** has no comparable general-purpose attested key. The App Attest
///   service issues a key it will only produce *assertions* with, so the
///   request "signature" is a CBOR assertion over the payload, the binding
///   carries the attestation object plus the key id, and device integrity comes
///   out of that same assertion - there is no second token to send.
class DeviceOs {
  const DeviceOs._();

  static bool get isIos => Platform.isIOS;

  /// The value DOA switches on, in the casing its API uses.
  static String get wireName => isIos ? 'Ios' : 'Android';

  static UserDeviceOs get model =>
      isIos ? UserDeviceOs.ios : UserDeviceOs.android;
}

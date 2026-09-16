// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_register_device_passkeys_verify_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingRegisterDevicePasskeysVerifyRequest
_$DeviceBindingRegisterDevicePasskeysVerifyRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingRegisterDevicePasskeysVerifyRequest', json, (
  $checkedConvert,
) {
  $checkKeys(
    json,
    requiredKeys: const ['assertion', 'requestChallenge', 'deviceAttestation'],
  );
  final val = DeviceBindingRegisterDevicePasskeysVerifyRequest(
    scope: $checkedConvert('scope', (v) => v as String?),
    assertion: $checkedConvert('assertion', (v) => v as String),
    identifier: $checkedConvert('identifier', (v) => v as String?),
    deviceBoundIntegrityVerificationData: $checkedConvert(
      'deviceBoundIntegrityVerificationData',
      (v) => v == null
          ? null
          : DeviceBoundIntegrityVerificationData.fromJson(
              v as Map<String, dynamic>,
            ),
    ),
    requestChallenge: $checkedConvert('requestChallenge', (v) => v as String?),
    deviceAttestation: $checkedConvert(
      'deviceAttestation',
      (v) => DeviceAttestationDto.fromJson(v as Map<String, dynamic>),
    ),
    iosHardwareKey: $checkedConvert('iosHardwareKey', (v) => v as String?),
    androidIntegrityToken: $checkedConvert(
      'androidIntegrityToken',
      (v) => v as String?,
    ),
    deviceData: $checkedConvert(
      'deviceData',
      (v) =>
          v == null ? null : UserDeviceData.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingRegisterDevicePasskeysVerifyRequestToJson(
  DeviceBindingRegisterDevicePasskeysVerifyRequest instance,
) => <String, dynamic>{
  'scope': ?instance.scope,
  'assertion': instance.assertion,
  'identifier': ?instance.identifier,
  'deviceBoundIntegrityVerificationData': ?instance
      .deviceBoundIntegrityVerificationData
      ?.toJson(),
  'requestChallenge': instance.requestChallenge,
  'deviceAttestation': instance.deviceAttestation.toJson(),
  'iosHardwareKey': ?instance.iosHardwareKey,
  'androidIntegrityToken': ?instance.androidIntegrityToken,
  'deviceData': ?instance.deviceData?.toJson(),
};

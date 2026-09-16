// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_passkeys_login_verify_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingPasskeysLoginVerifyRequest
_$DeviceBindingPasskeysLoginVerifyRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingPasskeysLoginVerifyRequest', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['assertion']);
  final val = DeviceBindingPasskeysLoginVerifyRequest(
    requestChallenge: $checkedConvert('requestChallenge', (v) => v as String?),
    scope: $checkedConvert('scope', (v) => v as String?),
    deviceData: $checkedConvert(
      'deviceData',
      (v) =>
          v == null ? null : UserDeviceData.fromJson(v as Map<String, dynamic>),
    ),
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
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingPasskeysLoginVerifyRequestToJson(
  DeviceBindingPasskeysLoginVerifyRequest instance,
) => <String, dynamic>{
  'requestChallenge': ?instance.requestChallenge,
  'scope': ?instance.scope,
  'deviceData': ?instance.deviceData?.toJson(),
  'assertion': instance.assertion,
  'identifier': ?instance.identifier,
  'deviceBoundIntegrityVerificationData': ?instance
      .deviceBoundIntegrityVerificationData
      ?.toJson(),
};

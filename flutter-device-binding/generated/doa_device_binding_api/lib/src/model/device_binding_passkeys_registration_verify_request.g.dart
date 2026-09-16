// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_passkeys_registration_verify_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingPasskeysRegistrationVerifyRequest
_$DeviceBindingPasskeysRegistrationVerifyRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingPasskeysRegistrationVerifyRequest', json, (
  $checkedConvert,
) {
  $checkKeys(
    json,
    requiredKeys: const [
      'passkeyAttestation',
      'identifier',
      'deviceAttestation',
      'requestChallenge',
      'loginScope',
    ],
  );
  final val = DeviceBindingPasskeysRegistrationVerifyRequest(
    language: $checkedConvert('language', (v) => v as String?),
    roleKey: $checkedConvert('roleKey', (v) => v as String?),
    licenseKey: $checkedConvert('licenseKey', (v) => v as String?),
    passkeyAttestation: $checkedConvert(
      'passkeyAttestation',
      (v) => v as String?,
    ),
    identifier: $checkedConvert('identifier', (v) => v as String?),
    deviceAttestation: $checkedConvert(
      'deviceAttestation',
      (v) => DeviceAttestationDto.fromJson(v as Map<String, dynamic>),
    ),
    requestChallenge: $checkedConvert('requestChallenge', (v) => v as String?),
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
    loginScope: $checkedConvert('loginScope', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingPasskeysRegistrationVerifyRequestToJson(
  DeviceBindingPasskeysRegistrationVerifyRequest instance,
) => <String, dynamic>{
  'language': ?instance.language,
  'roleKey': ?instance.roleKey,
  'licenseKey': ?instance.licenseKey,
  'passkeyAttestation': instance.passkeyAttestation,
  'identifier': instance.identifier,
  'deviceAttestation': instance.deviceAttestation.toJson(),
  'requestChallenge': instance.requestChallenge,
  'iosHardwareKey': ?instance.iosHardwareKey,
  'androidIntegrityToken': ?instance.androidIntegrityToken,
  'deviceData': ?instance.deviceData?.toJson(),
  'loginScope': instance.loginScope,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_register_username_account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingRegisterUsernameAccountRequest
_$DeviceBindingRegisterUsernameAccountRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingRegisterUsernameAccountRequest', json, (
  $checkedConvert,
) {
  $checkKeys(
    json,
    requiredKeys: const [
      'password',
      'username',
      'deviceAttestation',
      'requestChallenge',
    ],
  );
  final val = DeviceBindingRegisterUsernameAccountRequest(
    language: $checkedConvert('language', (v) => v as String?),
    roleKey: $checkedConvert('roleKey', (v) => v as String?),
    licenseKey: $checkedConvert('licenseKey', (v) => v as String?),
    password: $checkedConvert('password', (v) => v as String?),
    username: $checkedConvert('username', (v) => v as String?),
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
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingRegisterUsernameAccountRequestToJson(
  DeviceBindingRegisterUsernameAccountRequest instance,
) => <String, dynamic>{
  'language': ?instance.language,
  'roleKey': ?instance.roleKey,
  'licenseKey': ?instance.licenseKey,
  'password': instance.password,
  'username': instance.username,
  'deviceAttestation': instance.deviceAttestation.toJson(),
  'requestChallenge': instance.requestChallenge,
  'iosHardwareKey': ?instance.iosHardwareKey,
  'androidIntegrityToken': ?instance.androidIntegrityToken,
  'deviceData': ?instance.deviceData?.toJson(),
};

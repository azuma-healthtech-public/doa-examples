// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_register_email_account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingRegisterEmailAccountRequest
_$DeviceBindingRegisterEmailAccountRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingRegisterEmailAccountRequest', json, (
  $checkedConvert,
) {
  $checkKeys(
    json,
    requiredKeys: const [
      'password',
      'email',
      'initiateEmailVerification',
      'deviceAttestation',
      'requestChallenge',
    ],
  );
  final val = DeviceBindingRegisterEmailAccountRequest(
    language: $checkedConvert('language', (v) => v as String?),
    roleKey: $checkedConvert('roleKey', (v) => v as String?),
    licenseKey: $checkedConvert('licenseKey', (v) => v as String?),
    password: $checkedConvert('password', (v) => v as String?),
    email: $checkedConvert('email', (v) => v as String?),
    initiateEmailVerification: $checkedConvert(
      'initiateEmailVerification',
      (v) => v as bool,
    ),
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

Map<String, dynamic> _$DeviceBindingRegisterEmailAccountRequestToJson(
  DeviceBindingRegisterEmailAccountRequest instance,
) => <String, dynamic>{
  'language': ?instance.language,
  'roleKey': ?instance.roleKey,
  'licenseKey': ?instance.licenseKey,
  'password': instance.password,
  'email': instance.email,
  'initiateEmailVerification': instance.initiateEmailVerification,
  'deviceAttestation': instance.deviceAttestation.toJson(),
  'requestChallenge': instance.requestChallenge,
  'iosHardwareKey': ?instance.iosHardwareKey,
  'androidIntegrityToken': ?instance.androidIntegrityToken,
  'deviceData': ?instance.deviceData?.toJson(),
};

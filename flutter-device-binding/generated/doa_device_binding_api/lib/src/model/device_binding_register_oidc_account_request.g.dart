// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_register_oidc_account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingRegisterOidcAccountRequest
_$DeviceBindingRegisterOidcAccountRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingRegisterOidcAccountRequest', json, (
  $checkedConvert,
) {
  $checkKeys(
    json,
    requiredKeys: const ['deviceAttestation', 'requestChallenge'],
  );
  final val = DeviceBindingRegisterOidcAccountRequest(
    language: $checkedConvert('language', (v) => v as String?),
    roleKey: $checkedConvert('roleKey', (v) => v as String?),
    licenseKey: $checkedConvert('licenseKey', (v) => v as String?),
    identityToken: $checkedConvert('identityToken', (v) => v as String?),
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

Map<String, dynamic> _$DeviceBindingRegisterOidcAccountRequestToJson(
  DeviceBindingRegisterOidcAccountRequest instance,
) => <String, dynamic>{
  'language': ?instance.language,
  'roleKey': ?instance.roleKey,
  'licenseKey': ?instance.licenseKey,
  'identityToken': ?instance.identityToken,
  'deviceAttestation': instance.deviceAttestation.toJson(),
  'requestChallenge': instance.requestChallenge,
  'iosHardwareKey': ?instance.iosHardwareKey,
  'androidIntegrityToken': ?instance.androidIntegrityToken,
  'deviceData': ?instance.deviceData?.toJson(),
};

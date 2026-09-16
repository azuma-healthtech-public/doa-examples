// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_register_additional_device_email_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingRegisterAdditionalDeviceEmailRequest
_$DeviceBindingRegisterAdditionalDeviceEmailRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingRegisterAdditionalDeviceEmailRequest', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['email', 'deviceAttestation']);
  final val = DeviceBindingRegisterAdditionalDeviceEmailRequest(
    password: $checkedConvert('password', (v) => v as String?),
    scope: $checkedConvert('scope', (v) => v as String?),
    requestChallenge: $checkedConvert('requestChallenge', (v) => v as String?),
    deviceData: $checkedConvert(
      'deviceData',
      (v) =>
          v == null ? null : UserDeviceData.fromJson(v as Map<String, dynamic>),
    ),
    deviceAttestationKey: $checkedConvert(
      'deviceAttestationKey',
      (v) => v as String?,
    ),
    email: $checkedConvert('email', (v) => v as String?),
    deviceBoundIntegrityVerificationData: $checkedConvert(
      'deviceBoundIntegrityVerificationData',
      (v) => v == null
          ? null
          : DeviceBoundIntegrityVerificationData.fromJson(
              v as Map<String, dynamic>,
            ),
    ),
    deviceAttestation: $checkedConvert(
      'deviceAttestation',
      (v) => DeviceAttestationDto.fromJson(v as Map<String, dynamic>),
    ),
    iosHardwareKey: $checkedConvert('iosHardwareKey', (v) => v as String?),
    androidIntegrityToken: $checkedConvert(
      'androidIntegrityToken',
      (v) => v as String?,
    ),
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingRegisterAdditionalDeviceEmailRequestToJson(
  DeviceBindingRegisterAdditionalDeviceEmailRequest instance,
) => <String, dynamic>{
  'password': ?instance.password,
  'scope': ?instance.scope,
  'requestChallenge': ?instance.requestChallenge,
  'deviceData': ?instance.deviceData?.toJson(),
  'deviceAttestationKey': ?instance.deviceAttestationKey,
  'email': instance.email,
  'deviceBoundIntegrityVerificationData': ?instance
      .deviceBoundIntegrityVerificationData
      ?.toJson(),
  'deviceAttestation': instance.deviceAttestation.toJson(),
  'iosHardwareKey': ?instance.iosHardwareKey,
  'androidIntegrityToken': ?instance.androidIntegrityToken,
};

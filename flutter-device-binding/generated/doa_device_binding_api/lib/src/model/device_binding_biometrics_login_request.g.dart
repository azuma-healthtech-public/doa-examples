// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_biometrics_login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingBiometricsLoginRequest
_$DeviceBindingBiometricsLoginRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingBiometricsLoginRequest', json, (
  $checkedConvert,
) {
  final val = DeviceBindingBiometricsLoginRequest(
    id: $checkedConvert('id', (v) => v as String?),
    requestSignature: $checkedConvert('requestSignature', (v) => v as String?),
    requestChallenge: $checkedConvert('requestChallenge', (v) => v as String?),
    scope: $checkedConvert('scope', (v) => v as String?),
    deviceData: $checkedConvert(
      'deviceData',
      (v) =>
          v == null ? null : UserDeviceData.fromJson(v as Map<String, dynamic>),
    ),
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

Map<String, dynamic> _$DeviceBindingBiometricsLoginRequestToJson(
  DeviceBindingBiometricsLoginRequest instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'requestSignature': ?instance.requestSignature,
  'requestChallenge': ?instance.requestChallenge,
  'scope': ?instance.scope,
  'deviceData': ?instance.deviceData?.toJson(),
  'deviceBoundIntegrityVerificationData': ?instance
      .deviceBoundIntegrityVerificationData
      ?.toJson(),
};

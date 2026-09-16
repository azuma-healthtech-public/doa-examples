// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_refresh_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingRefreshRequest _$DeviceBindingRefreshRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingRefreshRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['deviceAttestation']);
  final val = DeviceBindingRefreshRequest(
    accessToken: $checkedConvert('accessToken', (v) => v as String?),
    deviceAttestationKey: $checkedConvert(
      'deviceAttestationKey',
      (v) => v as String?,
    ),
    requestChallenge: $checkedConvert('requestChallenge', (v) => v as String?),
    deviceData: $checkedConvert(
      'deviceData',
      (v) =>
          v == null ? null : UserDeviceData.fromJson(v as Map<String, dynamic>),
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

Map<String, dynamic> _$DeviceBindingRefreshRequestToJson(
  DeviceBindingRefreshRequest instance,
) => <String, dynamic>{
  'accessToken': ?instance.accessToken,
  'deviceAttestationKey': ?instance.deviceAttestationKey,
  'requestChallenge': ?instance.requestChallenge,
  'deviceData': ?instance.deviceData?.toJson(),
  'deviceAttestation': instance.deviceAttestation.toJson(),
  'iosHardwareKey': ?instance.iosHardwareKey,
  'androidIntegrityToken': ?instance.androidIntegrityToken,
};

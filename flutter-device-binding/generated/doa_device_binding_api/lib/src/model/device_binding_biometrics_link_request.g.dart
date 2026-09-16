// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_biometrics_link_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingBiometricsLinkRequest _$DeviceBindingBiometricsLinkRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingBiometricsLinkRequest', json, (
  $checkedConvert,
) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'accessToken',
      'publicKey',
      'requestChallenge',
      'requestSignature',
    ],
  );
  final val = DeviceBindingBiometricsLinkRequest(
    id: $checkedConvert('id', (v) => v as String?),
    accessToken: $checkedConvert('accessToken', (v) => v as String?),
    publicKey: $checkedConvert('publicKey', (v) => v as String?),
    deviceData: $checkedConvert(
      'deviceData',
      (v) =>
          v == null ? null : UserDeviceData.fromJson(v as Map<String, dynamic>),
    ),
    requestChallenge: $checkedConvert('requestChallenge', (v) => v as String?),
    requestSignature: $checkedConvert('requestSignature', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingBiometricsLinkRequestToJson(
  DeviceBindingBiometricsLinkRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'accessToken': instance.accessToken,
  'publicKey': instance.publicKey,
  'deviceData': ?instance.deviceData?.toJson(),
  'requestChallenge': instance.requestChallenge,
  'requestSignature': instance.requestSignature,
};

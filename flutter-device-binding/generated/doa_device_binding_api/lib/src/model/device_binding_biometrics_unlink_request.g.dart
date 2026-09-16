// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_biometrics_unlink_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingBiometricsUnlinkRequest
_$DeviceBindingBiometricsUnlinkRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeviceBindingBiometricsUnlinkRequest', json, (
      $checkedConvert,
    ) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'accessToken', 'biometricsId'],
      );
      final val = DeviceBindingBiometricsUnlinkRequest(
        id: $checkedConvert('id', (v) => v as String?),
        accessToken: $checkedConvert('accessToken', (v) => v as String?),
        biometricsId: $checkedConvert('biometricsId', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$DeviceBindingBiometricsUnlinkRequestToJson(
  DeviceBindingBiometricsUnlinkRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'accessToken': instance.accessToken,
  'biometricsId': instance.biometricsId,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_bound_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBoundRequest _$DeviceBoundRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeviceBoundRequest', json, ($checkedConvert) {
      final val = DeviceBoundRequest(
        signature: $checkedConvert('signature', (v) => v as String?),
        deviceOs: $checkedConvert(
          'deviceOs',
          (v) => $enumDecodeNullable(_$UserDeviceOsEnumMap, v),
        ),
        payload: $checkedConvert('payload', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$DeviceBoundRequestToJson(DeviceBoundRequest instance) =>
    <String, dynamic>{
      'signature': ?instance.signature,
      'deviceOs': ?_$UserDeviceOsEnumMap[instance.deviceOs],
      'payload': ?instance.payload,
    };

const _$UserDeviceOsEnumMap = {
  UserDeviceOs.unknown: 'Unknown',
  UserDeviceOs.android: 'Android',
  UserDeviceOs.ios: 'Ios',
};

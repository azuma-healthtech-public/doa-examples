// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_device_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDeviceData _$UserDeviceDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserDeviceData', json, ($checkedConvert) {
      final val = UserDeviceData(
        name: $checkedConvert('name', (v) => v as String?),
        manufacturer: $checkedConvert('manufacturer', (v) => v as String?),
        model: $checkedConvert('model', (v) => v as String?),
        modelVersion: $checkedConvert('modelVersion', (v) => v as String?),
        osVersion: $checkedConvert('osVersion', (v) => v as String?),
        os: $checkedConvert('os', (v) => v as String?),
        extra: $checkedConvert('extra', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$UserDeviceDataToJson(UserDeviceData instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'manufacturer': ?instance.manufacturer,
      'model': ?instance.model,
      'modelVersion': ?instance.modelVersion,
      'osVersion': ?instance.osVersion,
      'os': ?instance.os,
      'extra': ?instance.extra,
    };

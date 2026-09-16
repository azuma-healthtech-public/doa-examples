// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_attestation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceAttestationDto _$DeviceAttestationDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceAttestationDto', json, ($checkedConvert) {
  final val = DeviceAttestationDto(
    deviceName: $checkedConvert('deviceName', (v) => v as String?),
    attestation: $checkedConvert('attestation', (v) => v as String?),
    deviceOs: $checkedConvert(
      'deviceOs',
      (v) => $enumDecodeNullable(_$UserDeviceOsEnumMap, v),
    ),
  );
  return val;
});

Map<String, dynamic> _$DeviceAttestationDtoToJson(
  DeviceAttestationDto instance,
) => <String, dynamic>{
  'deviceName': ?instance.deviceName,
  'attestation': ?instance.attestation,
  'deviceOs': ?_$UserDeviceOsEnumMap[instance.deviceOs],
};

const _$UserDeviceOsEnumMap = {
  UserDeviceOs.unknown: 'Unknown',
  UserDeviceOs.android: 'Android',
  UserDeviceOs.ios: 'Ios',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_register_health_id_account_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingRegisterHealthIdAccountResponse
_$DeviceBindingRegisterHealthIdAccountResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingRegisterHealthIdAccountResponse', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['id']);
  final val = DeviceBindingRegisterHealthIdAccountResponse(
    id: $checkedConvert('id', (v) => v as String?),
    deviceAttestationKey: $checkedConvert(
      'deviceAttestationKey',
      (v) => v as String?,
    ),
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingRegisterHealthIdAccountResponseToJson(
  DeviceBindingRegisterHealthIdAccountResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'deviceAttestationKey': ?instance.deviceAttestationKey,
};

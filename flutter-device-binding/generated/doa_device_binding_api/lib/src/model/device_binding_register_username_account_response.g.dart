// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_register_username_account_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingRegisterUsernameAccountResponse
_$DeviceBindingRegisterUsernameAccountResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingRegisterUsernameAccountResponse', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['id']);
  final val = DeviceBindingRegisterUsernameAccountResponse(
    id: $checkedConvert('id', (v) => v as String?),
    deviceAttestationKey: $checkedConvert(
      'deviceAttestationKey',
      (v) => v as String?,
    ),
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingRegisterUsernameAccountResponseToJson(
  DeviceBindingRegisterUsernameAccountResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'deviceAttestationKey': ?instance.deviceAttestationKey,
};

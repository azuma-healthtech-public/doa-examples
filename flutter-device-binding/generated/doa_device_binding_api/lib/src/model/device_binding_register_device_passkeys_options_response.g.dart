// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_register_device_passkeys_options_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingRegisterDevicePasskeysOptionsResponse
_$DeviceBindingRegisterDevicePasskeysOptionsResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'DeviceBindingRegisterDevicePasskeysOptionsResponse',
  json,
  ($checkedConvert) {
    final val = DeviceBindingRegisterDevicePasskeysOptionsResponse(
      accountId: $checkedConvert('accountId', (v) => v as String?),
      options: $checkedConvert('options', (v) => v as String?),
    );
    return val;
  },
);

Map<String, dynamic> _$DeviceBindingRegisterDevicePasskeysOptionsResponseToJson(
  DeviceBindingRegisterDevicePasskeysOptionsResponse instance,
) => <String, dynamic>{
  'accountId': ?instance.accountId,
  'options': ?instance.options,
};

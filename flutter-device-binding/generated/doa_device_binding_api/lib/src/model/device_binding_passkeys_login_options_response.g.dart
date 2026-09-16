// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_passkeys_login_options_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingPasskeysLoginOptionsResponse
_$DeviceBindingPasskeysLoginOptionsResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingPasskeysLoginOptionsResponse', json, (
  $checkedConvert,
) {
  final val = DeviceBindingPasskeysLoginOptionsResponse(
    accountId: $checkedConvert('accountId', (v) => v as String?),
    options: $checkedConvert('options', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingPasskeysLoginOptionsResponseToJson(
  DeviceBindingPasskeysLoginOptionsResponse instance,
) => <String, dynamic>{
  'accountId': ?instance.accountId,
  'options': ?instance.options,
};

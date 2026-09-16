// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_register_device_passkeys_verify_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingRegisterDevicePasskeysVerifyResponse
_$DeviceBindingRegisterDevicePasskeysVerifyResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingRegisterDevicePasskeysVerifyResponse', json, (
  $checkedConvert,
) {
  final val = DeviceBindingRegisterDevicePasskeysVerifyResponse(
    id: $checkedConvert('id', (v) => v as String?),
    token: $checkedConvert(
      'token',
      (v) =>
          v == null ? null : LoginResponse.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingRegisterDevicePasskeysVerifyResponseToJson(
  DeviceBindingRegisterDevicePasskeysVerifyResponse instance,
) => <String, dynamic>{'id': ?instance.id, 'token': ?instance.token?.toJson()};

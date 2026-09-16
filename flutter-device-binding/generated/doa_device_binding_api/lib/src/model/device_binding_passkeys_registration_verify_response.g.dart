// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_passkeys_registration_verify_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingPasskeysRegistrationVerifyResponse
_$DeviceBindingPasskeysRegistrationVerifyResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingPasskeysRegistrationVerifyResponse', json, (
  $checkedConvert,
) {
  final val = DeviceBindingPasskeysRegistrationVerifyResponse(
    id: $checkedConvert('id', (v) => v as String?),
    token: $checkedConvert(
      'token',
      (v) =>
          v == null ? null : LoginResponse.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingPasskeysRegistrationVerifyResponseToJson(
  DeviceBindingPasskeysRegistrationVerifyResponse instance,
) => <String, dynamic>{'id': ?instance.id, 'token': ?instance.token?.toJson()};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_passkeys_registration_options_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingPasskeysRegistrationOptionsResponse
_$DeviceBindingPasskeysRegistrationOptionsResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingPasskeysRegistrationOptionsResponse', json, (
  $checkedConvert,
) {
  final val = DeviceBindingPasskeysRegistrationOptionsResponse(
    options: $checkedConvert('options', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingPasskeysRegistrationOptionsResponseToJson(
  DeviceBindingPasskeysRegistrationOptionsResponse instance,
) => <String, dynamic>{'options': ?instance.options};

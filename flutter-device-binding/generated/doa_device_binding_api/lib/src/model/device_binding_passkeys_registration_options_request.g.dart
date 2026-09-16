// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_passkeys_registration_options_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingPasskeysRegistrationOptionsRequest
_$DeviceBindingPasskeysRegistrationOptionsRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingPasskeysRegistrationOptionsRequest', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['identifier']);
  final val = DeviceBindingPasskeysRegistrationOptionsRequest(
    identifier: $checkedConvert('identifier', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingPasskeysRegistrationOptionsRequestToJson(
  DeviceBindingPasskeysRegistrationOptionsRequest instance,
) => <String, dynamic>{'identifier': instance.identifier};

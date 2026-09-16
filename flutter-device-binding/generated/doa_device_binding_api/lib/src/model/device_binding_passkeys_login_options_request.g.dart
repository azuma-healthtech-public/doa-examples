// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_passkeys_login_options_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingPasskeysLoginOptionsRequest
_$DeviceBindingPasskeysLoginOptionsRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeviceBindingPasskeysLoginOptionsRequest', json, (
      $checkedConvert,
    ) {
      $checkKeys(json, requiredKeys: const ['identifier']);
      final val = DeviceBindingPasskeysLoginOptionsRequest(
        identifier: $checkedConvert('identifier', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$DeviceBindingPasskeysLoginOptionsRequestToJson(
  DeviceBindingPasskeysLoginOptionsRequest instance,
) => <String, dynamic>{'identifier': instance.identifier};

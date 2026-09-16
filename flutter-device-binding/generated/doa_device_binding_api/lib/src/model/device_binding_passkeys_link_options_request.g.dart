// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_passkeys_link_options_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingPasskeysLinkOptionsRequest
_$DeviceBindingPasskeysLinkOptionsRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeviceBindingPasskeysLinkOptionsRequest', json, (
      $checkedConvert,
    ) {
      $checkKeys(json, requiredKeys: const ['id', 'accessToken']);
      final val = DeviceBindingPasskeysLinkOptionsRequest(
        id: $checkedConvert('id', (v) => v as String?),
        accessToken: $checkedConvert('accessToken', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$DeviceBindingPasskeysLinkOptionsRequestToJson(
  DeviceBindingPasskeysLinkOptionsRequest instance,
) => <String, dynamic>{'id': instance.id, 'accessToken': instance.accessToken};

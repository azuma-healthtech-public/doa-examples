// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_passkeys_link_options_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingPasskeysLinkOptionsResponse
_$DeviceBindingPasskeysLinkOptionsResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeviceBindingPasskeysLinkOptionsResponse', json, (
      $checkedConvert,
    ) {
      final val = DeviceBindingPasskeysLinkOptionsResponse(
        accountId: $checkedConvert('accountId', (v) => v as String?),
        options: $checkedConvert('options', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$DeviceBindingPasskeysLinkOptionsResponseToJson(
  DeviceBindingPasskeysLinkOptionsResponse instance,
) => <String, dynamic>{
  'accountId': ?instance.accountId,
  'options': ?instance.options,
};

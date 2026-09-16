// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_passkeys_unlink_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingPasskeysUnlinkRequest _$DeviceBindingPasskeysUnlinkRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingPasskeysUnlinkRequest', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['id', 'accessToken', 'passkeyId']);
  final val = DeviceBindingPasskeysUnlinkRequest(
    id: $checkedConvert('id', (v) => v as String?),
    accessToken: $checkedConvert('accessToken', (v) => v as String?),
    passkeyId: $checkedConvert('passkeyId', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingPasskeysUnlinkRequestToJson(
  DeviceBindingPasskeysUnlinkRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'accessToken': instance.accessToken,
  'passkeyId': instance.passkeyId,
};

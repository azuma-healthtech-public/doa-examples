// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_un_link_health_id_account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingUnLinkHealthIdAccountRequest
_$DeviceBindingUnLinkHealthIdAccountRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingUnLinkHealthIdAccountRequest', json, (
  $checkedConvert,
) {
  final val = DeviceBindingUnLinkHealthIdAccountRequest(
    id: $checkedConvert('id', (v) => v as String?),
    accessToken: $checkedConvert('accessToken', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingUnLinkHealthIdAccountRequestToJson(
  DeviceBindingUnLinkHealthIdAccountRequest instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'accessToken': ?instance.accessToken,
};

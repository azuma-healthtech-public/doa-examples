// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_link_health_id_account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingLinkHealthIdAccountRequest
_$DeviceBindingLinkHealthIdAccountRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeviceBindingLinkHealthIdAccountRequest', json, (
      $checkedConvert,
    ) {
      final val = DeviceBindingLinkHealthIdAccountRequest(
        id: $checkedConvert('id', (v) => v as String?),
        accessToken: $checkedConvert('accessToken', (v) => v as String?),
        healthIdIdentityToken: $checkedConvert(
          'healthIdIdentityToken',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$DeviceBindingLinkHealthIdAccountRequestToJson(
  DeviceBindingLinkHealthIdAccountRequest instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'accessToken': ?instance.accessToken,
  'healthIdIdentityToken': ?instance.healthIdIdentityToken,
};

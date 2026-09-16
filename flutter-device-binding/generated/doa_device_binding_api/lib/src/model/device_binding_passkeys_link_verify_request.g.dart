// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_passkeys_link_verify_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingPasskeysLinkVerifyRequest
_$DeviceBindingPasskeysLinkVerifyRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeviceBindingPasskeysLinkVerifyRequest', json, (
      $checkedConvert,
    ) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'accessToken', 'passkeyAttestation'],
      );
      final val = DeviceBindingPasskeysLinkVerifyRequest(
        id: $checkedConvert('id', (v) => v as String?),
        accessToken: $checkedConvert('accessToken', (v) => v as String?),
        passkeyAttestation: $checkedConvert(
          'passkeyAttestation',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$DeviceBindingPasskeysLinkVerifyRequestToJson(
  DeviceBindingPasskeysLinkVerifyRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'accessToken': instance.accessToken,
  'passkeyAttestation': instance.passkeyAttestation,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_register_oidc_account_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingRegisterOidcAccountResponse
_$DeviceBindingRegisterOidcAccountResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeviceBindingRegisterOidcAccountResponse', json, (
      $checkedConvert,
    ) {
      $checkKeys(json, requiredKeys: const ['id']);
      final val = DeviceBindingRegisterOidcAccountResponse(
        id: $checkedConvert('id', (v) => v as String?),
        deviceAttestationKey: $checkedConvert(
          'deviceAttestationKey',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$DeviceBindingRegisterOidcAccountResponseToJson(
  DeviceBindingRegisterOidcAccountResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'deviceAttestationKey': ?instance.deviceAttestationKey,
};

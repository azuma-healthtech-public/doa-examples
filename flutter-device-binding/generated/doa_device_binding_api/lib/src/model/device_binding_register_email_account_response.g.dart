// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_register_email_account_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingRegisterEmailAccountResponse
_$DeviceBindingRegisterEmailAccountResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingRegisterEmailAccountResponse', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['id']);
  final val = DeviceBindingRegisterEmailAccountResponse(
    id: $checkedConvert('id', (v) => v as String?),
    emailVerificationInitiated: $checkedConvert(
      'emailVerificationInitiated',
      (v) => v as bool?,
    ),
    verificationFlow: $checkedConvert('verificationFlow', (v) => v as String?),
    deviceAttestationKey: $checkedConvert(
      'deviceAttestationKey',
      (v) => v as String?,
    ),
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingRegisterEmailAccountResponseToJson(
  DeviceBindingRegisterEmailAccountResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'emailVerificationInitiated': ?instance.emailVerificationInitiated,
  'verificationFlow': ?instance.verificationFlow,
  'deviceAttestationKey': ?instance.deviceAttestationKey,
};

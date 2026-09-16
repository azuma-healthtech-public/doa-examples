// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_email_recovery_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmEmailRecoveryRequest _$ConfirmEmailRecoveryRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ConfirmEmailRecoveryRequest', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['email', 'recoveryFlow', 'recoveryCode'],
  );
  final val = ConfirmEmailRecoveryRequest(
    email: $checkedConvert('email', (v) => v as String?),
    recoveryFlow: $checkedConvert('recoveryFlow', (v) => v as String?),
    recoveryCode: $checkedConvert('recoveryCode', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$ConfirmEmailRecoveryRequestToJson(
  ConfirmEmailRecoveryRequest instance,
) => <String, dynamic>{
  'email': instance.email,
  'recoveryFlow': instance.recoveryFlow,
  'recoveryCode': instance.recoveryCode,
};

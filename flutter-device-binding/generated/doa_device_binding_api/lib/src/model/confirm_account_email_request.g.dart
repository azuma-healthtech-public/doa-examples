// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_account_email_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmAccountEmailRequest _$ConfirmAccountEmailRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ConfirmAccountEmailRequest', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['email', 'verificationFlow', 'verificationCode'],
  );
  final val = ConfirmAccountEmailRequest(
    email: $checkedConvert('email', (v) => v as String?),
    verificationFlow: $checkedConvert('verificationFlow', (v) => v as String?),
    verificationCode: $checkedConvert('verificationCode', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$ConfirmAccountEmailRequestToJson(
  ConfirmAccountEmailRequest instance,
) => <String, dynamic>{
  'email': instance.email,
  'verificationFlow': instance.verificationFlow,
  'verificationCode': instance.verificationCode,
};

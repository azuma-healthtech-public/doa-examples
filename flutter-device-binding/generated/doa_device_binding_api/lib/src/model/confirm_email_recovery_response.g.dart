// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_email_recovery_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmEmailRecoveryResponse _$ConfirmEmailRecoveryResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ConfirmEmailRecoveryResponse', json, ($checkedConvert) {
  final val = ConfirmEmailRecoveryResponse(
    passwordChangeToken: $checkedConvert(
      'passwordChangeToken',
      (v) => v as String?,
    ),
    passwordChangeId: $checkedConvert('passwordChangeId', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$ConfirmEmailRecoveryResponseToJson(
  ConfirmEmailRecoveryResponse instance,
) => <String, dynamic>{
  'passwordChangeToken': ?instance.passwordChangeToken,
  'passwordChangeId': ?instance.passwordChangeId,
};

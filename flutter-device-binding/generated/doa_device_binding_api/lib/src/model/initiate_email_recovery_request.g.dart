// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initiate_email_recovery_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InitiateEmailRecoveryRequest _$InitiateEmailRecoveryRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('InitiateEmailRecoveryRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['email']);
  final val = InitiateEmailRecoveryRequest(
    email: $checkedConvert('email', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$InitiateEmailRecoveryRequestToJson(
  InitiateEmailRecoveryRequest instance,
) => <String, dynamic>{'email': instance.email};

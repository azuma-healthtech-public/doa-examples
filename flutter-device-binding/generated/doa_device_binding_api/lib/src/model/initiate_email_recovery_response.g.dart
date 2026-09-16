// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initiate_email_recovery_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InitiateEmailRecoveryResponse _$InitiateEmailRecoveryResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('InitiateEmailRecoveryResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['recoveryFlow']);
  final val = InitiateEmailRecoveryResponse(
    recoveryFlow: $checkedConvert('recoveryFlow', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$InitiateEmailRecoveryResponseToJson(
  InitiateEmailRecoveryResponse instance,
) => <String, dynamic>{'recoveryFlow': instance.recoveryFlow};

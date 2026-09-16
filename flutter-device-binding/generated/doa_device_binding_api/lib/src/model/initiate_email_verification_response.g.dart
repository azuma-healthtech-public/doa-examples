// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initiate_email_verification_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InitiateEmailVerificationResponse _$InitiateEmailVerificationResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('InitiateEmailVerificationResponse', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['verificationFlow']);
  final val = InitiateEmailVerificationResponse(
    verificationFlow: $checkedConvert('verificationFlow', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$InitiateEmailVerificationResponseToJson(
  InitiateEmailVerificationResponse instance,
) => <String, dynamic>{'verificationFlow': instance.verificationFlow};

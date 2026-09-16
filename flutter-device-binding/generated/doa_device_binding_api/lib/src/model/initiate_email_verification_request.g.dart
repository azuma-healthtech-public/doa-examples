// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initiate_email_verification_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InitiateEmailVerificationRequest _$InitiateEmailVerificationRequestFromJson(
  Map<String, dynamic> json,
) =>
    $checkedCreate('InitiateEmailVerificationRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['email']);
      final val = InitiateEmailVerificationRequest(
        email: $checkedConvert('email', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$InitiateEmailVerificationRequestToJson(
  InitiateEmailVerificationRequest instance,
) => <String, dynamic>{'email': instance.email};

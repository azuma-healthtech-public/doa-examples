// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_email_account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginEmailAccountRequest _$LoginEmailAccountRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('LoginEmailAccountRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['email']);
  final val = LoginEmailAccountRequest(
    password: $checkedConvert('password', (v) => v as String?),
    scope: $checkedConvert('scope', (v) => v as String?),
    requestChallenge: $checkedConvert('requestChallenge', (v) => v as String?),
    deviceData: $checkedConvert(
      'deviceData',
      (v) =>
          v == null ? null : UserDeviceData.fromJson(v as Map<String, dynamic>),
    ),
    deviceAttestationKey: $checkedConvert(
      'deviceAttestationKey',
      (v) => v as String?,
    ),
    email: $checkedConvert('email', (v) => v as String?),
    deviceBoundIntegrityVerificationData: $checkedConvert(
      'deviceBoundIntegrityVerificationData',
      (v) => v == null
          ? null
          : DeviceBoundIntegrityVerificationData.fromJson(
              v as Map<String, dynamic>,
            ),
    ),
  );
  return val;
});

Map<String, dynamic> _$LoginEmailAccountRequestToJson(
  LoginEmailAccountRequest instance,
) => <String, dynamic>{
  'password': ?instance.password,
  'scope': ?instance.scope,
  'requestChallenge': ?instance.requestChallenge,
  'deviceData': ?instance.deviceData?.toJson(),
  'deviceAttestationKey': ?instance.deviceAttestationKey,
  'email': instance.email,
  'deviceBoundIntegrityVerificationData': ?instance
      .deviceBoundIntegrityVerificationData
      ?.toJson(),
};

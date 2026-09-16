// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_username_account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginUsernameAccountRequest _$LoginUsernameAccountRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('LoginUsernameAccountRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['username']);
  final val = LoginUsernameAccountRequest(
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
    username: $checkedConvert('username', (v) => v as String?),
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

Map<String, dynamic> _$LoginUsernameAccountRequestToJson(
  LoginUsernameAccountRequest instance,
) => <String, dynamic>{
  'password': ?instance.password,
  'scope': ?instance.scope,
  'requestChallenge': ?instance.requestChallenge,
  'deviceData': ?instance.deviceData?.toJson(),
  'deviceAttestationKey': ?instance.deviceAttestationKey,
  'username': instance.username,
  'deviceBoundIntegrityVerificationData': ?instance
      .deviceBoundIntegrityVerificationData
      ?.toJson(),
};

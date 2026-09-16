// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginAccountRequest _$LoginAccountRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('LoginAccountRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['identifier']);
  final val = LoginAccountRequest(
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
    identifier: $checkedConvert('identifier', (v) => v as String?),
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

Map<String, dynamic> _$LoginAccountRequestToJson(
  LoginAccountRequest instance,
) => <String, dynamic>{
  'password': ?instance.password,
  'scope': ?instance.scope,
  'requestChallenge': ?instance.requestChallenge,
  'deviceData': ?instance.deviceData?.toJson(),
  'deviceAttestationKey': ?instance.deviceAttestationKey,
  'identifier': instance.identifier,
  'deviceBoundIntegrityVerificationData': ?instance
      .deviceBoundIntegrityVerificationData
      ?.toJson(),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_bound_request_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBoundRequestPayload _$DeviceBoundRequestPayloadFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBoundRequestPayload', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'email',
      'verificationFlow',
      'verificationCode',
      'recoveryFlow',
      'recoveryCode',
      'deviceAttestation',
      'token',
      'username',
      'identityToken',
      'refreshToken',
    ],
  );
  final val = DeviceBoundRequestPayload(
    email: $checkedConvert('email', (v) => v as String?),
    password: $checkedConvert('password', (v) => v as String?),
    passwordChangeToken: $checkedConvert(
      'passwordChangeToken',
      (v) => v as String?,
    ),
    passwordChangeId: $checkedConvert('passwordChangeId', (v) => v as String?),
    identifier: $checkedConvert('identifier', (v) => v as String?),
    newPassword: $checkedConvert('newPassword', (v) => v as String?),
    oldPassword: $checkedConvert('oldPassword', (v) => v as String?),
    accessToken: $checkedConvert('accessToken', (v) => v as String?),
    verificationFlow: $checkedConvert('verificationFlow', (v) => v as String?),
    verificationCode: $checkedConvert('verificationCode', (v) => v as String?),
    recoveryFlow: $checkedConvert('recoveryFlow', (v) => v as String?),
    recoveryCode: $checkedConvert('recoveryCode', (v) => v as String?),
    deviceAttestationKey: $checkedConvert(
      'deviceAttestationKey',
      (v) => v as String?,
    ),
    requestChallenge: $checkedConvert('requestChallenge', (v) => v as String?),
    deviceData: $checkedConvert(
      'deviceData',
      (v) =>
          v == null ? null : UserDeviceData.fromJson(v as Map<String, dynamic>),
    ),
    deviceAttestation: $checkedConvert(
      'deviceAttestation',
      (v) => DeviceAttestationDto.fromJson(v as Map<String, dynamic>),
    ),
    iosHardwareKey: $checkedConvert('iosHardwareKey', (v) => v as String?),
    androidIntegrityToken: $checkedConvert(
      'androidIntegrityToken',
      (v) => v as String?,
    ),
    id: $checkedConvert('id', (v) => v as String?),
    healthIdIdentityToken: $checkedConvert(
      'healthIdIdentityToken',
      (v) => v as String?,
    ),
    token: $checkedConvert('token', (v) => v as String?),
    scope: $checkedConvert('scope', (v) => v as String?),
    deviceBoundIntegrityVerificationData: $checkedConvert(
      'deviceBoundIntegrityVerificationData',
      (v) => v == null
          ? null
          : DeviceBoundIntegrityVerificationData.fromJson(
              v as Map<String, dynamic>,
            ),
    ),
    username: $checkedConvert('username', (v) => v as String?),
    identityToken: $checkedConvert('identityToken', (v) => v as String?),
    refreshToken: $checkedConvert('refreshToken', (v) => v as String?),
    globalLogout: $checkedConvert('globalLogout', (v) => v as bool?),
  );
  return val;
});

Map<String, dynamic> _$DeviceBoundRequestPayloadToJson(
  DeviceBoundRequestPayload instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': ?instance.password,
  'passwordChangeToken': ?instance.passwordChangeToken,
  'passwordChangeId': ?instance.passwordChangeId,
  'identifier': ?instance.identifier,
  'newPassword': ?instance.newPassword,
  'oldPassword': ?instance.oldPassword,
  'accessToken': ?instance.accessToken,
  'verificationFlow': instance.verificationFlow,
  'verificationCode': instance.verificationCode,
  'recoveryFlow': instance.recoveryFlow,
  'recoveryCode': instance.recoveryCode,
  'deviceAttestationKey': ?instance.deviceAttestationKey,
  'requestChallenge': ?instance.requestChallenge,
  'deviceData': ?instance.deviceData?.toJson(),
  'deviceAttestation': instance.deviceAttestation.toJson(),
  'iosHardwareKey': ?instance.iosHardwareKey,
  'androidIntegrityToken': ?instance.androidIntegrityToken,
  'id': ?instance.id,
  'healthIdIdentityToken': ?instance.healthIdIdentityToken,
  'token': instance.token,
  'scope': ?instance.scope,
  'deviceBoundIntegrityVerificationData': ?instance
      .deviceBoundIntegrityVerificationData
      ?.toJson(),
  'username': instance.username,
  'identityToken': instance.identityToken,
  'refreshToken': instance.refreshToken,
  'globalLogout': ?instance.globalLogout,
};

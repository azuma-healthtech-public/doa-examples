// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_health_id_account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginHealthIdAccountRequest _$LoginHealthIdAccountRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('LoginHealthIdAccountRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['identityToken']);
  final val = LoginHealthIdAccountRequest(
    identityToken: $checkedConvert('identityToken', (v) => v as String?),
    requestChallenge: $checkedConvert('requestChallenge', (v) => v as String?),
    scope: $checkedConvert('scope', (v) => v as String?),
    deviceData: $checkedConvert(
      'deviceData',
      (v) =>
          v == null ? null : UserDeviceData.fromJson(v as Map<String, dynamic>),
    ),
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

Map<String, dynamic> _$LoginHealthIdAccountRequestToJson(
  LoginHealthIdAccountRequest instance,
) => <String, dynamic>{
  'identityToken': instance.identityToken,
  'requestChallenge': ?instance.requestChallenge,
  'scope': ?instance.scope,
  'deviceData': ?instance.deviceData?.toJson(),
  'deviceBoundIntegrityVerificationData': ?instance
      .deviceBoundIntegrityVerificationData
      ?.toJson(),
};

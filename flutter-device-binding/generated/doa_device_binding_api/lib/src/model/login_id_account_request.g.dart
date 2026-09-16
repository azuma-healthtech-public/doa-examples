// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_id_account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginIdAccountRequest _$LoginIdAccountRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('LoginIdAccountRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['id']);
  final val = LoginIdAccountRequest(
    scope: $checkedConvert('scope', (v) => v as String?),
    requestChallenge: $checkedConvert('requestChallenge', (v) => v as String?),
    deviceData: $checkedConvert(
      'deviceData',
      (v) =>
          v == null ? null : UserDeviceData.fromJson(v as Map<String, dynamic>),
    ),
    id: $checkedConvert('id', (v) => v as String?),
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

Map<String, dynamic> _$LoginIdAccountRequestToJson(
  LoginIdAccountRequest instance,
) => <String, dynamic>{
  'scope': ?instance.scope,
  'requestChallenge': ?instance.requestChallenge,
  'deviceData': ?instance.deviceData?.toJson(),
  'id': instance.id,
  'deviceBoundIntegrityVerificationData': ?instance
      .deviceBoundIntegrityVerificationData
      ?.toJson(),
};

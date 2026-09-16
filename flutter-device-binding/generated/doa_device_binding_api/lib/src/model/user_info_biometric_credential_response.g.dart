// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_biometric_credential_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoBiometricCredentialResponse
_$UserInfoBiometricCredentialResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserInfoBiometricCredentialResponse', json, (
      $checkedConvert,
    ) {
      final val = UserInfoBiometricCredentialResponse(
        id: $checkedConvert('id', (v) => v as String?),
        deviceData: $checkedConvert(
          'deviceData',
          (v) => v == null
              ? null
              : UserDeviceData.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$UserInfoBiometricCredentialResponseToJson(
  UserInfoBiometricCredentialResponse instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'deviceData': ?instance.deviceData?.toJson(),
};

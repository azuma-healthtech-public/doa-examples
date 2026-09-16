// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_bound_integrity_verification_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBoundIntegrityVerificationData
_$DeviceBoundIntegrityVerificationDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeviceBoundIntegrityVerificationData', json, (
      $checkedConvert,
    ) {
      final val = DeviceBoundIntegrityVerificationData(
        challenge: $checkedConvert('challenge', (v) => v as String?),
        androidIntegrityToken: $checkedConvert(
          'androidIntegrityToken',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$DeviceBoundIntegrityVerificationDataToJson(
  DeviceBoundIntegrityVerificationData instance,
) => <String, dynamic>{
  'challenge': ?instance.challenge,
  'androidIntegrityToken': ?instance.androidIntegrityToken,
};

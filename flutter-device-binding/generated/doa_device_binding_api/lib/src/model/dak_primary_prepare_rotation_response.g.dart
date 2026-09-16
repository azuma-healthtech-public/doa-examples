// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dak_primary_prepare_rotation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DakPrimaryPrepareRotationResponse _$DakPrimaryPrepareRotationResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DakPrimaryPrepareRotationResponse', json, (
  $checkedConvert,
) {
  final val = DakPrimaryPrepareRotationResponse(
    deviceAttestationKey: $checkedConvert(
      'deviceAttestationKey',
      (v) => v as String?,
    ),
  );
  return val;
});

Map<String, dynamic> _$DakPrimaryPrepareRotationResponseToJson(
  DakPrimaryPrepareRotationResponse instance,
) => <String, dynamic>{'deviceAttestationKey': ?instance.deviceAttestationKey};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dak_primary_rotate_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DakPrimaryRotateRequest _$DakPrimaryRotateRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DakPrimaryRotateRequest', json, ($checkedConvert) {
  final val = DakPrimaryRotateRequest(
    accessToken: $checkedConvert('accessToken', (v) => v as String?),
    deviceAttestationKey: $checkedConvert(
      'deviceAttestationKey',
      (v) => v as String?,
    ),
  );
  return val;
});

Map<String, dynamic> _$DakPrimaryRotateRequestToJson(
  DakPrimaryRotateRequest instance,
) => <String, dynamic>{
  'accessToken': ?instance.accessToken,
  'deviceAttestationKey': ?instance.deviceAttestationKey,
};

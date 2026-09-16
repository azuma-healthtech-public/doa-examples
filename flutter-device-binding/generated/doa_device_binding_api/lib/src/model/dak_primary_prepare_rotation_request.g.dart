// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dak_primary_prepare_rotation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DakPrimaryPrepareRotationRequest _$DakPrimaryPrepareRotationRequestFromJson(
  Map<String, dynamic> json,
) =>
    $checkedCreate('DakPrimaryPrepareRotationRequest', json, ($checkedConvert) {
      final val = DakPrimaryPrepareRotationRequest(
        accessToken: $checkedConvert('accessToken', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$DakPrimaryPrepareRotationRequestToJson(
  DakPrimaryPrepareRotationRequest instance,
) => <String, dynamic>{'accessToken': ?instance.accessToken};

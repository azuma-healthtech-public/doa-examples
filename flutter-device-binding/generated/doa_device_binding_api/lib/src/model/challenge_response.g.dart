// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeResponse _$ChallengeResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ChallengeResponse', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['challenge']);
      final val = ChallengeResponse(
        challenge: $checkedConvert('challenge', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ChallengeResponseToJson(ChallengeResponse instance) =>
    <String, dynamic>{'challenge': instance.challenge};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revoke_token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RevokeTokenRequest _$RevokeTokenRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RevokeTokenRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['token']);
      final val = RevokeTokenRequest(
        id: $checkedConvert('id', (v) => v as String?),
        token: $checkedConvert('token', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$RevokeTokenRequestToJson(RevokeTokenRequest instance) =>
    <String, dynamic>{'id': ?instance.id, 'token': instance.token};

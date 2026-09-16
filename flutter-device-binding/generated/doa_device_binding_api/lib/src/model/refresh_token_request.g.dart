// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshTokenRequest _$RefreshTokenRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RefreshTokenRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['refreshToken']);
      final val = RefreshTokenRequest(
        id: $checkedConvert('id', (v) => v as String?),
        refreshToken: $checkedConvert('refreshToken', (v) => v as String?),
        requestChallenge: $checkedConvert(
          'requestChallenge',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$RefreshTokenRequestToJson(
  RefreshTokenRequest instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'refreshToken': instance.refreshToken,
  'requestChallenge': ?instance.requestChallenge,
};

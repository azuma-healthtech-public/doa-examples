// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TokenResponse', json, ($checkedConvert) {
      final val = TokenResponse(
        accessToken: $checkedConvert('accessToken', (v) => v as String?),
        tokenType: $checkedConvert('tokenType', (v) => v as String?),
        expiresInSeconds: $checkedConvert(
          'expiresInSeconds',
          (v) => (v as num?)?.toInt(),
        ),
        refreshToken: $checkedConvert('refreshToken', (v) => v as String?),
        scope: $checkedConvert('scope', (v) => v as String?),
        idToken: $checkedConvert('idToken', (v) => v as String?),
        issued: $checkedConvert(
          'issued',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        issuedUtc: $checkedConvert(
          'issuedUtc',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        isStale: $checkedConvert('isStale', (v) => v as bool?),
      );
      return val;
    });

Map<String, dynamic> _$TokenResponseToJson(TokenResponse instance) =>
    <String, dynamic>{
      'accessToken': ?instance.accessToken,
      'tokenType': ?instance.tokenType,
      'expiresInSeconds': ?instance.expiresInSeconds,
      'refreshToken': ?instance.refreshToken,
      'scope': ?instance.scope,
      'idToken': ?instance.idToken,
      'issued': ?instance.issued?.toIso8601String(),
      'issuedUtc': ?instance.issuedUtc?.toIso8601String(),
      'isStale': ?instance.isStale,
    };

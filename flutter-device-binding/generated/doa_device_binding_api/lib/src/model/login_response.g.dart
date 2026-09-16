// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LoginResponse', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'accessToken',
          'expiresIn',
          'scope',
          'tokenType',
          'postLoginActions',
        ],
      );
      final val = LoginResponse(
        accessToken: $checkedConvert('accessToken', (v) => v as String?),
        expiresIn: $checkedConvert('expiresIn', (v) => (v as num).toInt()),
        refreshToken: $checkedConvert('refreshToken', (v) => v as String?),
        scope: $checkedConvert('scope', (v) => v as String?),
        tokenType: $checkedConvert('tokenType', (v) => v as String?),
        postLoginActions: $checkedConvert(
          'postLoginActions',
          (v) => (v as List<dynamic>?)
              ?.map((e) => PostLoginAction.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'expiresIn': instance.expiresIn,
      'refreshToken': ?instance.refreshToken,
      'scope': instance.scope,
      'tokenType': instance.tokenType,
      'postLoginActions': instance.postLoginActions
          ?.map((e) => e.toJson())
          .toList(),
    };

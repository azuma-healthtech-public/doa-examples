// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logout_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogoutUserRequest _$LogoutUserRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LogoutUserRequest', json, ($checkedConvert) {
      final val = LogoutUserRequest(
        id: $checkedConvert('id', (v) => v as String?),
        accessToken: $checkedConvert('accessToken', (v) => v as String?),
        refreshToken: $checkedConvert('refreshToken', (v) => v as String?),
        globalLogout: $checkedConvert('globalLogout', (v) => v as bool?),
      );
      return val;
    });

Map<String, dynamic> _$LogoutUserRequestToJson(LogoutUserRequest instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'accessToken': ?instance.accessToken,
      'refreshToken': ?instance.refreshToken,
      'globalLogout': ?instance.globalLogout,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoRequest _$UserInfoRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserInfoRequest', json, ($checkedConvert) {
      final val = UserInfoRequest(
        id: $checkedConvert('id', (v) => v as String?),
        accessToken: $checkedConvert('accessToken', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$UserInfoRequestToJson(UserInfoRequest instance) =>
    <String, dynamic>{'id': ?instance.id, 'accessToken': ?instance.accessToken};

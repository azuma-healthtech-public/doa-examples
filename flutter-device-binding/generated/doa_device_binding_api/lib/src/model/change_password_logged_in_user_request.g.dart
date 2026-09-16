// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_logged_in_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordLoggedInUserRequest _$ChangePasswordLoggedInUserRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ChangePasswordLoggedInUserRequest', json, (
  $checkedConvert,
) {
  final val = ChangePasswordLoggedInUserRequest(
    identifier: $checkedConvert('identifier', (v) => v as String?),
    newPassword: $checkedConvert('newPassword', (v) => v as String?),
    oldPassword: $checkedConvert('oldPassword', (v) => v as String?),
    accessToken: $checkedConvert('accessToken', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$ChangePasswordLoggedInUserRequestToJson(
  ChangePasswordLoggedInUserRequest instance,
) => <String, dynamic>{
  'identifier': ?instance.identifier,
  'newPassword': ?instance.newPassword,
  'oldPassword': ?instance.oldPassword,
  'accessToken': ?instance.accessToken,
};

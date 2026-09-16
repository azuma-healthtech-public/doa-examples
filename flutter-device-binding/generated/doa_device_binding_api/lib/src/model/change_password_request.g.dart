// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordRequest _$ChangePasswordRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ChangePasswordRequest', json, ($checkedConvert) {
  final val = ChangePasswordRequest(
    email: $checkedConvert('email', (v) => v as String?),
    password: $checkedConvert('password', (v) => v as String?),
    passwordChangeToken: $checkedConvert(
      'passwordChangeToken',
      (v) => v as String?,
    ),
    passwordChangeId: $checkedConvert('passwordChangeId', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$ChangePasswordRequestToJson(
  ChangePasswordRequest instance,
) => <String, dynamic>{
  'email': ?instance.email,
  'password': ?instance.password,
  'passwordChangeToken': ?instance.passwordChangeToken,
  'passwordChangeId': ?instance.passwordChangeId,
};

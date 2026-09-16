// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_passkey_credential_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoPasskeyCredentialResponse _$UserInfoPasskeyCredentialResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('UserInfoPasskeyCredentialResponse', json, (
  $checkedConvert,
) {
  final val = UserInfoPasskeyCredentialResponse(
    id: $checkedConvert('id', (v) => v as String?),
    credentialId: $checkedConvert('credentialId', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$UserInfoPasskeyCredentialResponseToJson(
  UserInfoPasskeyCredentialResponse instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'credentialId': ?instance.credentialId,
};

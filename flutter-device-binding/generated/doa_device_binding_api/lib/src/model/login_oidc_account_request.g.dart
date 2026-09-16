// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_oidc_account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginOidcAccountRequest _$LoginOidcAccountRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('LoginOidcAccountRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['identityToken']);
  final val = LoginOidcAccountRequest(
    identityToken: $checkedConvert('identityToken', (v) => v as String?),
    requestChallenge: $checkedConvert('requestChallenge', (v) => v as String?),
    scope: $checkedConvert('scope', (v) => v as String?),
    deviceData: $checkedConvert(
      'deviceData',
      (v) =>
          v == null ? null : UserDeviceData.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$LoginOidcAccountRequestToJson(
  LoginOidcAccountRequest instance,
) => <String, dynamic>{
  'identityToken': instance.identityToken,
  'requestChallenge': ?instance.requestChallenge,
  'scope': ?instance.scope,
  'deviceData': ?instance.deviceData?.toJson(),
};

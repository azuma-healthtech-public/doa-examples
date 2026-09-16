// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoResponse _$UserInfoResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserInfoResponse', json, ($checkedConvert) {
      final val = UserInfoResponse(
        id: $checkedConvert('id', (v) => v as String?),
        linkedAuthenticationMethods: $checkedConvert(
          'linkedAuthenticationMethods',
          (v) => (v as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ExternalOidcProviderEnumMap, e))
              .toList(),
        ),
        linkedAuthentications: $checkedConvert(
          'linkedAuthentications',
          (v) => (v as List<dynamic>?)
              ?.map(
                (e) => UserInfoLinkedAuthenticationResponse.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
        ),
        registrationStatus: $checkedConvert(
          'registrationStatus',
          (v) => $enumDecodeNullable(_$UserRegistrationStatusEnumMap, v),
        ),
        passkeyCredentials: $checkedConvert(
          'passkeyCredentials',
          (v) => (v as List<dynamic>?)
              ?.map(
                (e) => UserInfoPasskeyCredentialResponse.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
        ),
        biometricCredentials: $checkedConvert(
          'biometricCredentials',
          (v) => (v as List<dynamic>?)
              ?.map(
                (e) => UserInfoBiometricCredentialResponse.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$UserInfoResponseToJson(UserInfoResponse instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'linkedAuthenticationMethods': ?instance.linkedAuthenticationMethods
          ?.map((e) => _$ExternalOidcProviderEnumMap[e]!)
          .toList(),
      'linkedAuthentications': ?instance.linkedAuthentications
          ?.map((e) => e.toJson())
          .toList(),
      'registrationStatus':
          ?_$UserRegistrationStatusEnumMap[instance.registrationStatus],
      'passkeyCredentials': ?instance.passkeyCredentials
          ?.map((e) => e.toJson())
          .toList(),
      'biometricCredentials': ?instance.biometricCredentials
          ?.map((e) => e.toJson())
          .toList(),
    };

const _$ExternalOidcProviderEnumMap = {
  ExternalOidcProvider.mimoto: 'Mimoto',
  ExternalOidcProvider.google: 'Google',
  ExternalOidcProvider.apple: 'Apple',
  ExternalOidcProvider.hin: 'Hin',
};

const _$UserRegistrationStatusEnumMap = {
  UserRegistrationStatus.pending: 'Pending',
  UserRegistrationStatus.invited: 'Invited',
  UserRegistrationStatus.finished: 'Finished',
};

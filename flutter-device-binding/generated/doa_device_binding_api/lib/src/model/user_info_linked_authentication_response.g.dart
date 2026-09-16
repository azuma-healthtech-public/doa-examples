// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_linked_authentication_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoLinkedAuthenticationResponse
_$UserInfoLinkedAuthenticationResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserInfoLinkedAuthenticationResponse', json, (
      $checkedConvert,
    ) {
      final val = UserInfoLinkedAuthenticationResponse(
        provider: $checkedConvert(
          'provider',
          (v) => $enumDecodeNullable(_$ExternalOidcProviderEnumMap, v),
        ),
        sub: $checkedConvert('sub', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$UserInfoLinkedAuthenticationResponseToJson(
  UserInfoLinkedAuthenticationResponse instance,
) => <String, dynamic>{
  'provider': ?_$ExternalOidcProviderEnumMap[instance.provider],
  'sub': ?instance.sub,
};

const _$ExternalOidcProviderEnumMap = {
  ExternalOidcProvider.mimoto: 'Mimoto',
  ExternalOidcProvider.google: 'Google',
  ExternalOidcProvider.apple: 'Apple',
  ExternalOidcProvider.hin: 'Hin',
};

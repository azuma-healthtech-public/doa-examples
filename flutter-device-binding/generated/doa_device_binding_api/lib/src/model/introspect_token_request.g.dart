// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'introspect_token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntrospectTokenRequest _$IntrospectTokenRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('IntrospectTokenRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['token']);
  final val = IntrospectTokenRequest(
    id: $checkedConvert('id', (v) => v as String?),
    token: $checkedConvert('token', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$IntrospectTokenRequestToJson(
  IntrospectTokenRequest instance,
) => <String, dynamic>{'id': ?instance.id, 'token': instance.token};

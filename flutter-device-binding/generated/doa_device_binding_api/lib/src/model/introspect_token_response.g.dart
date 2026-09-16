// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'introspect_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntrospectTokenResponse _$IntrospectTokenResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('IntrospectTokenResponse', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['active']);
  final val = IntrospectTokenResponse(
    active: $checkedConvert('active', (v) => v as bool),
  );
  return val;
});

Map<String, dynamic> _$IntrospectTokenResponseToJson(
  IntrospectTokenResponse instance,
) => <String, dynamic>{'active': instance.active};

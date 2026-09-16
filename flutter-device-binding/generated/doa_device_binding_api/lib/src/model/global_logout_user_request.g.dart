// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_logout_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlobalLogoutUserRequest _$GlobalLogoutUserRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('GlobalLogoutUserRequest', json, ($checkedConvert) {
  final val = GlobalLogoutUserRequest(
    id: $checkedConvert('id', (v) => v as String?),
    accessToken: $checkedConvert('accessToken', (v) => v as String?),
    refreshToken: $checkedConvert('refreshToken', (v) => v as String?),
    clearNotUsedDeviceBindings: $checkedConvert(
      'clearNotUsedDeviceBindings',
      (v) => v as bool?,
    ),
    clearCurrentDeviceBinding: $checkedConvert(
      'clearCurrentDeviceBinding',
      (v) => v as bool?,
    ),
  );
  return val;
});

Map<String, dynamic> _$GlobalLogoutUserRequestToJson(
  GlobalLogoutUserRequest instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'accessToken': ?instance.accessToken,
  'refreshToken': ?instance.refreshToken,
  'clearNotUsedDeviceBindings': ?instance.clearNotUsedDeviceBindings,
  'clearCurrentDeviceBinding': ?instance.clearCurrentDeviceBinding,
};

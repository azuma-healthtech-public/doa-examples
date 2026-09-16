// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_login_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostLoginAction _$PostLoginActionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PostLoginAction', json, ($checkedConvert) {
      final val = PostLoginAction(
        actionType: $checkedConvert(
          'actionType',
          (v) => $enumDecodeNullable(_$PostLoginActionTypeEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PostLoginActionToJson(PostLoginAction instance) =>
    <String, dynamic>{
      'actionType': ?_$PostLoginActionTypeEnumMap[instance.actionType],
    };

const _$PostLoginActionTypeEnumMap = {
  PostLoginActionType.passwordChangeRequired: 'PasswordChangeRequired',
  PostLoginActionType.deviceBindingExpired: 'DeviceBindingExpired',
  PostLoginActionType.deviceBindingNearingExpiration:
      'DeviceBindingNearingExpiration',
  PostLoginActionType.deviceAttestationKeyMissing:
      'DeviceAttestationKeyMissing',
};

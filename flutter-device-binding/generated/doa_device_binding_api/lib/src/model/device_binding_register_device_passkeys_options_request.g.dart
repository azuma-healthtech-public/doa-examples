// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_register_device_passkeys_options_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingRegisterDevicePasskeysOptionsRequest
_$DeviceBindingRegisterDevicePasskeysOptionsRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingRegisterDevicePasskeysOptionsRequest', json, (
  $checkedConvert,
) {
  final val = DeviceBindingRegisterDevicePasskeysOptionsRequest(
    identifier: $checkedConvert('identifier', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingRegisterDevicePasskeysOptionsRequestToJson(
  DeviceBindingRegisterDevicePasskeysOptionsRequest instance,
) => <String, dynamic>{'identifier': ?instance.identifier};

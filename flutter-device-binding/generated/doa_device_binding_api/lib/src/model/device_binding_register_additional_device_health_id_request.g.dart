// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_register_additional_device_health_id_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingRegisterAdditionalDeviceHealthIdRequest
_$DeviceBindingRegisterAdditionalDeviceHealthIdRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'DeviceBindingRegisterAdditionalDeviceHealthIdRequest',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const ['identityToken', 'deviceAttestation'],
    );
    final val = DeviceBindingRegisterAdditionalDeviceHealthIdRequest(
      identityToken: $checkedConvert('identityToken', (v) => v as String?),
      requestChallenge: $checkedConvert(
        'requestChallenge',
        (v) => v as String?,
      ),
      scope: $checkedConvert('scope', (v) => v as String?),
      deviceData: $checkedConvert(
        'deviceData',
        (v) => v == null
            ? null
            : UserDeviceData.fromJson(v as Map<String, dynamic>),
      ),
      deviceBoundIntegrityVerificationData: $checkedConvert(
        'deviceBoundIntegrityVerificationData',
        (v) => v == null
            ? null
            : DeviceBoundIntegrityVerificationData.fromJson(
                v as Map<String, dynamic>,
              ),
      ),
      deviceAttestation: $checkedConvert(
        'deviceAttestation',
        (v) => DeviceAttestationDto.fromJson(v as Map<String, dynamic>),
      ),
      iosHardwareKey: $checkedConvert('iosHardwareKey', (v) => v as String?),
      androidIntegrityToken: $checkedConvert(
        'androidIntegrityToken',
        (v) => v as String?,
      ),
    );
    return val;
  },
);

Map<String, dynamic>
_$DeviceBindingRegisterAdditionalDeviceHealthIdRequestToJson(
  DeviceBindingRegisterAdditionalDeviceHealthIdRequest instance,
) => <String, dynamic>{
  'identityToken': instance.identityToken,
  'requestChallenge': ?instance.requestChallenge,
  'scope': ?instance.scope,
  'deviceData': ?instance.deviceData?.toJson(),
  'deviceBoundIntegrityVerificationData': ?instance
      .deviceBoundIntegrityVerificationData
      ?.toJson(),
  'deviceAttestation': instance.deviceAttestation.toJson(),
  'iosHardwareKey': ?instance.iosHardwareKey,
  'androidIntegrityToken': ?instance.androidIntegrityToken,
};

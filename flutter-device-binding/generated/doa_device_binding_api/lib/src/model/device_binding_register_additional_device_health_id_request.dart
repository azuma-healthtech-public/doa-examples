//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/device_attestation_dto.dart';
import 'package:doa_device_binding_api/src/model/user_device_data.dart';
import 'package:doa_device_binding_api/src/model/device_bound_integrity_verification_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_register_additional_device_health_id_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingRegisterAdditionalDeviceHealthIdRequest {
  /// Returns a new [DeviceBindingRegisterAdditionalDeviceHealthIdRequest] instance.
  DeviceBindingRegisterAdditionalDeviceHealthIdRequest({

    required  this.identityToken,

     this.requestChallenge,

     this.scope,

     this.deviceData,

     this.deviceBoundIntegrityVerificationData,

    required  this.deviceAttestation,

     this.iosHardwareKey,

     this.androidIntegrityToken,
  });

  @JsonKey(
    
    name: r'identityToken',
    required: true,
    includeIfNull: true,
  )


  final String? identityToken;



      /// Challenge as received via challenge API.
  @JsonKey(
    
    name: r'requestChallenge',
    required: false,
    includeIfNull: false,
  )


  final String? requestChallenge;



      /// The following scopes are supported: - offline_access --> this is required to receive refresh token - permissions_app - licenses
  @JsonKey(
    
    name: r'scope',
    required: false,
    includeIfNull: false,
  )


  final String? scope;



  @JsonKey(
    
    name: r'deviceData',
    required: false,
    includeIfNull: false,
  )


  final UserDeviceData? deviceData;



  @JsonKey(
    
    name: r'deviceBoundIntegrityVerificationData',
    required: false,
    includeIfNull: false,
  )


  final DeviceBoundIntegrityVerificationData? deviceBoundIntegrityVerificationData;



  @JsonKey(
    
    name: r'deviceAttestation',
    required: true,
    includeIfNull: false,
  )


  final DeviceAttestationDto deviceAttestation;



      /// IOS only: hardware key.
  @JsonKey(
    
    name: r'iosHardwareKey',
    required: false,
    includeIfNull: false,
  )


  final String? iosHardwareKey;



      /// Android only: integrity token.
  @JsonKey(
    
    name: r'androidIntegrityToken',
    required: false,
    includeIfNull: false,
  )


  final String? androidIntegrityToken;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingRegisterAdditionalDeviceHealthIdRequest &&
      other.identityToken == identityToken &&
      other.requestChallenge == requestChallenge &&
      other.scope == scope &&
      other.deviceData == deviceData &&
      other.deviceBoundIntegrityVerificationData == deviceBoundIntegrityVerificationData &&
      other.deviceAttestation == deviceAttestation &&
      other.iosHardwareKey == iosHardwareKey &&
      other.androidIntegrityToken == androidIntegrityToken;

    @override
    int get hashCode =>
        (identityToken == null ? 0 : identityToken.hashCode) +
        (requestChallenge == null ? 0 : requestChallenge.hashCode) +
        (scope == null ? 0 : scope.hashCode) +
        deviceData.hashCode +
        deviceBoundIntegrityVerificationData.hashCode +
        deviceAttestation.hashCode +
        (iosHardwareKey == null ? 0 : iosHardwareKey.hashCode) +
        (androidIntegrityToken == null ? 0 : androidIntegrityToken.hashCode);

  factory DeviceBindingRegisterAdditionalDeviceHealthIdRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingRegisterAdditionalDeviceHealthIdRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingRegisterAdditionalDeviceHealthIdRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


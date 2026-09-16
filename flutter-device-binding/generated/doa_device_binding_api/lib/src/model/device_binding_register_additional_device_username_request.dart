//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/device_attestation_dto.dart';
import 'package:doa_device_binding_api/src/model/user_device_data.dart';
import 'package:doa_device_binding_api/src/model/device_bound_integrity_verification_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_register_additional_device_username_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingRegisterAdditionalDeviceUsernameRequest {
  /// Returns a new [DeviceBindingRegisterAdditionalDeviceUsernameRequest] instance.
  DeviceBindingRegisterAdditionalDeviceUsernameRequest({

     this.password,

     this.scope,

     this.requestChallenge,

     this.deviceData,

     this.deviceAttestationKey,

    required  this.username,

     this.deviceBoundIntegrityVerificationData,

    required  this.deviceAttestation,

     this.iosHardwareKey,

     this.androidIntegrityToken,
  });

  @JsonKey(
    
    name: r'password',
    required: false,
    includeIfNull: false,
  )


  final String? password;



      /// The following scopes are supported: - offline_access --> this is required to receive refresh token - permissions_app - licenses
  @JsonKey(
    
    name: r'scope',
    required: false,
    includeIfNull: false,
  )


  final String? scope;



      /// Challenge as received via challenge API.
  @JsonKey(
    
    name: r'requestChallenge',
    required: false,
    includeIfNull: false,
  )


  final String? requestChallenge;



  @JsonKey(
    
    name: r'deviceData',
    required: false,
    includeIfNull: false,
  )


  final UserDeviceData? deviceData;



      /// Device AttestationKey of the created account. DAK can be used instead of Password if enabled
  @JsonKey(
    
    name: r'deviceAttestationKey',
    required: false,
    includeIfNull: false,
  )


  final String? deviceAttestationKey;



  @JsonKey(
    
    name: r'username',
    required: true,
    includeIfNull: true,
  )


  final String? username;



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
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingRegisterAdditionalDeviceUsernameRequest &&
      other.password == password &&
      other.scope == scope &&
      other.requestChallenge == requestChallenge &&
      other.deviceData == deviceData &&
      other.deviceAttestationKey == deviceAttestationKey &&
      other.username == username &&
      other.deviceBoundIntegrityVerificationData == deviceBoundIntegrityVerificationData &&
      other.deviceAttestation == deviceAttestation &&
      other.iosHardwareKey == iosHardwareKey &&
      other.androidIntegrityToken == androidIntegrityToken;

    @override
    int get hashCode =>
        (password == null ? 0 : password.hashCode) +
        (scope == null ? 0 : scope.hashCode) +
        (requestChallenge == null ? 0 : requestChallenge.hashCode) +
        deviceData.hashCode +
        (deviceAttestationKey == null ? 0 : deviceAttestationKey.hashCode) +
        (username == null ? 0 : username.hashCode) +
        deviceBoundIntegrityVerificationData.hashCode +
        deviceAttestation.hashCode +
        (iosHardwareKey == null ? 0 : iosHardwareKey.hashCode) +
        (androidIntegrityToken == null ? 0 : androidIntegrityToken.hashCode);

  factory DeviceBindingRegisterAdditionalDeviceUsernameRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingRegisterAdditionalDeviceUsernameRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingRegisterAdditionalDeviceUsernameRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


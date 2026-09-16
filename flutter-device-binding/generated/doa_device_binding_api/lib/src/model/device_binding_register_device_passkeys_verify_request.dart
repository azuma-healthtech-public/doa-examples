//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/device_attestation_dto.dart';
import 'package:doa_device_binding_api/src/model/user_device_data.dart';
import 'package:doa_device_binding_api/src/model/device_bound_integrity_verification_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_register_device_passkeys_verify_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingRegisterDevicePasskeysVerifyRequest {
  /// Returns a new [DeviceBindingRegisterDevicePasskeysVerifyRequest] instance.
  DeviceBindingRegisterDevicePasskeysVerifyRequest({

     this.scope,

    required  this.assertion,

     this.identifier,

     this.deviceBoundIntegrityVerificationData,

    required  this.requestChallenge,

    required  this.deviceAttestation,

     this.iosHardwareKey,

     this.androidIntegrityToken,

     this.deviceData,
  });

      /// The following scopes are supported: - offline_access --> this is required to receive refresh token - permissions_app - licenses
  @JsonKey(
    
    name: r'scope',
    required: false,
    includeIfNull: false,
  )


  final String? scope;



  @JsonKey(
    
    name: r'assertion',
    required: true,
    includeIfNull: false,
  )


  final String assertion;



  @JsonKey(
    
    name: r'identifier',
    required: false,
    includeIfNull: false,
  )


  final String? identifier;



  @JsonKey(
    
    name: r'deviceBoundIntegrityVerificationData',
    required: false,
    includeIfNull: false,
  )


  final DeviceBoundIntegrityVerificationData? deviceBoundIntegrityVerificationData;



      /// Challenge as received via challenge API.
  @JsonKey(
    
    name: r'requestChallenge',
    required: true,
    includeIfNull: true,
  )


  final String? requestChallenge;



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



  @JsonKey(
    
    name: r'deviceData',
    required: false,
    includeIfNull: false,
  )


  final UserDeviceData? deviceData;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingRegisterDevicePasskeysVerifyRequest &&
      other.scope == scope &&
      other.assertion == assertion &&
      other.identifier == identifier &&
      other.deviceBoundIntegrityVerificationData == deviceBoundIntegrityVerificationData &&
      other.requestChallenge == requestChallenge &&
      other.deviceAttestation == deviceAttestation &&
      other.iosHardwareKey == iosHardwareKey &&
      other.androidIntegrityToken == androidIntegrityToken &&
      other.deviceData == deviceData;

    @override
    int get hashCode =>
        (scope == null ? 0 : scope.hashCode) +
        assertion.hashCode +
        (identifier == null ? 0 : identifier.hashCode) +
        deviceBoundIntegrityVerificationData.hashCode +
        (requestChallenge == null ? 0 : requestChallenge.hashCode) +
        deviceAttestation.hashCode +
        (iosHardwareKey == null ? 0 : iosHardwareKey.hashCode) +
        (androidIntegrityToken == null ? 0 : androidIntegrityToken.hashCode) +
        deviceData.hashCode;

  factory DeviceBindingRegisterDevicePasskeysVerifyRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingRegisterDevicePasskeysVerifyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingRegisterDevicePasskeysVerifyRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


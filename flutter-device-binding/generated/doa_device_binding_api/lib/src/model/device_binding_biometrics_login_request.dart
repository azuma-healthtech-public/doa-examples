//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/user_device_data.dart';
import 'package:doa_device_binding_api/src/model/device_bound_integrity_verification_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_biometrics_login_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingBiometricsLoginRequest {
  /// Returns a new [DeviceBindingBiometricsLoginRequest] instance.
  DeviceBindingBiometricsLoginRequest({

     this.id,

     this.requestSignature,

     this.requestChallenge,

     this.scope,

     this.deviceData,

     this.deviceBoundIntegrityVerificationData,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



      /// Base64-encoded signature of UTF-8(RequestChallenge). Algorithm must match the linked PublicKey: RSASSA-PKCS1-v1_5(SHA-256) for RSA-2048, or ECDSA(SHA-256, RFC 3279 DER) for EC P-256.
  @JsonKey(
    
    name: r'requestSignature',
    required: false,
    includeIfNull: false,
  )


  final String? requestSignature;



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





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingBiometricsLoginRequest &&
      other.id == id &&
      other.requestSignature == requestSignature &&
      other.requestChallenge == requestChallenge &&
      other.scope == scope &&
      other.deviceData == deviceData &&
      other.deviceBoundIntegrityVerificationData == deviceBoundIntegrityVerificationData;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        (requestSignature == null ? 0 : requestSignature.hashCode) +
        (requestChallenge == null ? 0 : requestChallenge.hashCode) +
        (scope == null ? 0 : scope.hashCode) +
        deviceData.hashCode +
        deviceBoundIntegrityVerificationData.hashCode;

  factory DeviceBindingBiometricsLoginRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingBiometricsLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingBiometricsLoginRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


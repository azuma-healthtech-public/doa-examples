//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/user_device_data.dart';
import 'package:doa_device_binding_api/src/model/device_bound_integrity_verification_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_passkeys_login_verify_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingPasskeysLoginVerifyRequest {
  /// Returns a new [DeviceBindingPasskeysLoginVerifyRequest] instance.
  DeviceBindingPasskeysLoginVerifyRequest({

     this.requestChallenge,

     this.scope,

     this.deviceData,

    required  this.assertion,

     this.identifier,

     this.deviceBoundIntegrityVerificationData,
  });

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





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingPasskeysLoginVerifyRequest &&
      other.requestChallenge == requestChallenge &&
      other.scope == scope &&
      other.deviceData == deviceData &&
      other.assertion == assertion &&
      other.identifier == identifier &&
      other.deviceBoundIntegrityVerificationData == deviceBoundIntegrityVerificationData;

    @override
    int get hashCode =>
        (requestChallenge == null ? 0 : requestChallenge.hashCode) +
        (scope == null ? 0 : scope.hashCode) +
        deviceData.hashCode +
        assertion.hashCode +
        (identifier == null ? 0 : identifier.hashCode) +
        deviceBoundIntegrityVerificationData.hashCode;

  factory DeviceBindingPasskeysLoginVerifyRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingPasskeysLoginVerifyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingPasskeysLoginVerifyRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


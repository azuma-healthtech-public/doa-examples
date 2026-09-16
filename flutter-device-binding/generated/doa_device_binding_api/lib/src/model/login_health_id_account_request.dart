//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/user_device_data.dart';
import 'package:doa_device_binding_api/src/model/device_bound_integrity_verification_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_health_id_account_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LoginHealthIdAccountRequest {
  /// Returns a new [LoginHealthIdAccountRequest] instance.
  LoginHealthIdAccountRequest({

    required  this.identityToken,

     this.requestChallenge,

     this.scope,

     this.deviceData,

     this.deviceBoundIntegrityVerificationData,
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





    @override
    bool operator ==(Object other) => identical(this, other) || other is LoginHealthIdAccountRequest &&
      other.identityToken == identityToken &&
      other.requestChallenge == requestChallenge &&
      other.scope == scope &&
      other.deviceData == deviceData &&
      other.deviceBoundIntegrityVerificationData == deviceBoundIntegrityVerificationData;

    @override
    int get hashCode =>
        (identityToken == null ? 0 : identityToken.hashCode) +
        (requestChallenge == null ? 0 : requestChallenge.hashCode) +
        (scope == null ? 0 : scope.hashCode) +
        deviceData.hashCode +
        deviceBoundIntegrityVerificationData.hashCode;

  factory LoginHealthIdAccountRequest.fromJson(Map<String, dynamic> json) => _$LoginHealthIdAccountRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginHealthIdAccountRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


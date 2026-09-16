//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/user_device_data.dart';
import 'package:doa_device_binding_api/src/model/device_bound_integrity_verification_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_email_account_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LoginEmailAccountRequest {
  /// Returns a new [LoginEmailAccountRequest] instance.
  LoginEmailAccountRequest({

     this.password,

     this.scope,

     this.requestChallenge,

     this.deviceData,

     this.deviceAttestationKey,

    required  this.email,

     this.deviceBoundIntegrityVerificationData,
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
    
    name: r'email',
    required: true,
    includeIfNull: true,
  )


  final String? email;



  @JsonKey(
    
    name: r'deviceBoundIntegrityVerificationData',
    required: false,
    includeIfNull: false,
  )


  final DeviceBoundIntegrityVerificationData? deviceBoundIntegrityVerificationData;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LoginEmailAccountRequest &&
      other.password == password &&
      other.scope == scope &&
      other.requestChallenge == requestChallenge &&
      other.deviceData == deviceData &&
      other.deviceAttestationKey == deviceAttestationKey &&
      other.email == email &&
      other.deviceBoundIntegrityVerificationData == deviceBoundIntegrityVerificationData;

    @override
    int get hashCode =>
        (password == null ? 0 : password.hashCode) +
        (scope == null ? 0 : scope.hashCode) +
        (requestChallenge == null ? 0 : requestChallenge.hashCode) +
        deviceData.hashCode +
        (deviceAttestationKey == null ? 0 : deviceAttestationKey.hashCode) +
        (email == null ? 0 : email.hashCode) +
        deviceBoundIntegrityVerificationData.hashCode;

  factory LoginEmailAccountRequest.fromJson(Map<String, dynamic> json) => _$LoginEmailAccountRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginEmailAccountRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/user_device_data.dart';
import 'package:doa_device_binding_api/src/model/device_bound_integrity_verification_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_id_account_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LoginIdAccountRequest {
  /// Returns a new [LoginIdAccountRequest] instance.
  LoginIdAccountRequest({

     this.scope,

     this.requestChallenge,

     this.deviceData,

    required  this.id,

     this.deviceBoundIntegrityVerificationData,
  });

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



  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: true,
  )


  final String? id;



  @JsonKey(
    
    name: r'deviceBoundIntegrityVerificationData',
    required: false,
    includeIfNull: false,
  )


  final DeviceBoundIntegrityVerificationData? deviceBoundIntegrityVerificationData;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LoginIdAccountRequest &&
      other.scope == scope &&
      other.requestChallenge == requestChallenge &&
      other.deviceData == deviceData &&
      other.id == id &&
      other.deviceBoundIntegrityVerificationData == deviceBoundIntegrityVerificationData;

    @override
    int get hashCode =>
        (scope == null ? 0 : scope.hashCode) +
        (requestChallenge == null ? 0 : requestChallenge.hashCode) +
        deviceData.hashCode +
        (id == null ? 0 : id.hashCode) +
        deviceBoundIntegrityVerificationData.hashCode;

  factory LoginIdAccountRequest.fromJson(Map<String, dynamic> json) => _$LoginIdAccountRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginIdAccountRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


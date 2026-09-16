//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/initiate_email_verification_request.dart';
import 'package:doa_device_binding_api/src/model/login_username_account_request.dart';
import 'package:doa_device_binding_api/src/model/user_device_data.dart';
import 'package:doa_device_binding_api/src/model/refresh_token_request.dart';
import 'package:doa_device_binding_api/src/model/device_bound_integrity_verification_data.dart';
import 'package:doa_device_binding_api/src/model/initiate_email_recovery_request.dart';
import 'package:doa_device_binding_api/src/model/logout_user_request.dart';
import 'package:doa_device_binding_api/src/model/revoke_token_request.dart';
import 'package:doa_device_binding_api/src/model/change_password_logged_in_user_request.dart';
import 'package:doa_device_binding_api/src/model/change_password_request.dart';
import 'package:doa_device_binding_api/src/model/login_health_id_account_request.dart';
import 'package:doa_device_binding_api/src/model/introspect_token_request.dart';
import 'package:doa_device_binding_api/src/model/dak_primary_rotate_request.dart';
import 'package:doa_device_binding_api/src/model/login_email_account_request.dart';
import 'package:doa_device_binding_api/src/model/dak_primary_prepare_rotation_request.dart';
import 'package:doa_device_binding_api/src/model/confirm_account_email_request.dart';
import 'package:doa_device_binding_api/src/model/device_binding_refresh_request.dart';
import 'package:doa_device_binding_api/src/model/device_attestation_dto.dart';
import 'package:doa_device_binding_api/src/model/device_binding_link_health_id_account_request.dart';
import 'package:doa_device_binding_api/src/model/user_info_request.dart';
import 'package:doa_device_binding_api/src/model/confirm_email_recovery_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_bound_request_payload.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBoundRequestPayload {
  /// Returns a new [DeviceBoundRequestPayload] instance.
  DeviceBoundRequestPayload({

    required  this.email,

     this.password,

     this.passwordChangeToken,

     this.passwordChangeId,

     this.identifier,

     this.newPassword,

     this.oldPassword,

     this.accessToken,

    required  this.verificationFlow,

    required  this.verificationCode,

    required  this.recoveryFlow,

    required  this.recoveryCode,

     this.deviceAttestationKey,

     this.requestChallenge,

     this.deviceData,

    required  this.deviceAttestation,

     this.iosHardwareKey,

     this.androidIntegrityToken,

     this.id,

     this.healthIdIdentityToken,

    required  this.token,

     this.scope,

     this.deviceBoundIntegrityVerificationData,

    required  this.username,

    required  this.identityToken,

    required  this.refreshToken,

     this.globalLogout,
  });

  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: true,
  )


  final String? email;



  @JsonKey(
    
    name: r'password',
    required: false,
    includeIfNull: false,
  )


  final String? password;



  @JsonKey(
    
    name: r'passwordChangeToken',
    required: false,
    includeIfNull: false,
  )


  final String? passwordChangeToken;



  @JsonKey(
    
    name: r'passwordChangeId',
    required: false,
    includeIfNull: false,
  )


  final String? passwordChangeId;



  @JsonKey(
    
    name: r'identifier',
    required: false,
    includeIfNull: false,
  )


  final String? identifier;



  @JsonKey(
    
    name: r'newPassword',
    required: false,
    includeIfNull: false,
  )


  final String? newPassword;



  @JsonKey(
    
    name: r'oldPassword',
    required: false,
    includeIfNull: false,
  )


  final String? oldPassword;



      /// doa Access Token.
  @JsonKey(
    
    name: r'accessToken',
    required: false,
    includeIfNull: false,
  )


  final String? accessToken;



      /// Verification flow.
  @JsonKey(
    
    name: r'verificationFlow',
    required: true,
    includeIfNull: true,
  )


  final String? verificationFlow;



      /// Verification code.
  @JsonKey(
    
    name: r'verificationCode',
    required: true,
    includeIfNull: true,
  )


  final String? verificationCode;



      /// Recovery flow.
  @JsonKey(
    
    name: r'recoveryFlow',
    required: true,
    includeIfNull: true,
  )


  final String? recoveryFlow;



      /// Recovery code.
  @JsonKey(
    
    name: r'recoveryCode',
    required: true,
    includeIfNull: true,
  )


  final String? recoveryCode;



      /// Device AttestationKey of the created account. DAK can be used instead of Password if enabled
  @JsonKey(
    
    name: r'deviceAttestationKey',
    required: false,
    includeIfNull: false,
  )


  final String? deviceAttestationKey;



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



      /// Account ID.
  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



      /// Identity token from mimoto.
  @JsonKey(
    
    name: r'healthIdIdentityToken',
    required: false,
    includeIfNull: false,
  )


  final String? healthIdIdentityToken;



      /// Access or refresh token to be revoked.
  @JsonKey(
    
    name: r'token',
    required: true,
    includeIfNull: true,
  )


  final String? token;



      /// The following scopes are supported: - offline_access --> this is required to receive refresh token - permissions_app - licenses
  @JsonKey(
    
    name: r'scope',
    required: false,
    includeIfNull: false,
  )


  final String? scope;



  @JsonKey(
    
    name: r'deviceBoundIntegrityVerificationData',
    required: false,
    includeIfNull: false,
  )


  final DeviceBoundIntegrityVerificationData? deviceBoundIntegrityVerificationData;



  @JsonKey(
    
    name: r'username',
    required: true,
    includeIfNull: true,
  )


  final String? username;



  @JsonKey(
    
    name: r'identityToken',
    required: true,
    includeIfNull: true,
  )


  final String? identityToken;



      /// Refresh token.
  @JsonKey(
    
    name: r'refreshToken',
    required: true,
    includeIfNull: true,
  )


  final String? refreshToken;



      /// If set to true, globally logs the user out. This will only work if AccessToken is valid!
  @JsonKey(
    
    name: r'globalLogout',
    required: false,
    includeIfNull: false,
  )


  final bool? globalLogout;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBoundRequestPayload &&
      other.email == email &&
      other.password == password &&
      other.passwordChangeToken == passwordChangeToken &&
      other.passwordChangeId == passwordChangeId &&
      other.identifier == identifier &&
      other.newPassword == newPassword &&
      other.oldPassword == oldPassword &&
      other.accessToken == accessToken &&
      other.verificationFlow == verificationFlow &&
      other.verificationCode == verificationCode &&
      other.recoveryFlow == recoveryFlow &&
      other.recoveryCode == recoveryCode &&
      other.deviceAttestationKey == deviceAttestationKey &&
      other.requestChallenge == requestChallenge &&
      other.deviceData == deviceData &&
      other.deviceAttestation == deviceAttestation &&
      other.iosHardwareKey == iosHardwareKey &&
      other.androidIntegrityToken == androidIntegrityToken &&
      other.id == id &&
      other.healthIdIdentityToken == healthIdIdentityToken &&
      other.token == token &&
      other.scope == scope &&
      other.deviceBoundIntegrityVerificationData == deviceBoundIntegrityVerificationData &&
      other.username == username &&
      other.identityToken == identityToken &&
      other.refreshToken == refreshToken &&
      other.globalLogout == globalLogout;

    @override
    int get hashCode =>
        (email == null ? 0 : email.hashCode) +
        (password == null ? 0 : password.hashCode) +
        (passwordChangeToken == null ? 0 : passwordChangeToken.hashCode) +
        (passwordChangeId == null ? 0 : passwordChangeId.hashCode) +
        (identifier == null ? 0 : identifier.hashCode) +
        (newPassword == null ? 0 : newPassword.hashCode) +
        (oldPassword == null ? 0 : oldPassword.hashCode) +
        (accessToken == null ? 0 : accessToken.hashCode) +
        (verificationFlow == null ? 0 : verificationFlow.hashCode) +
        (verificationCode == null ? 0 : verificationCode.hashCode) +
        (recoveryFlow == null ? 0 : recoveryFlow.hashCode) +
        (recoveryCode == null ? 0 : recoveryCode.hashCode) +
        (deviceAttestationKey == null ? 0 : deviceAttestationKey.hashCode) +
        (requestChallenge == null ? 0 : requestChallenge.hashCode) +
        deviceData.hashCode +
        deviceAttestation.hashCode +
        (iosHardwareKey == null ? 0 : iosHardwareKey.hashCode) +
        (androidIntegrityToken == null ? 0 : androidIntegrityToken.hashCode) +
        (id == null ? 0 : id.hashCode) +
        (healthIdIdentityToken == null ? 0 : healthIdIdentityToken.hashCode) +
        (token == null ? 0 : token.hashCode) +
        (scope == null ? 0 : scope.hashCode) +
        deviceBoundIntegrityVerificationData.hashCode +
        (username == null ? 0 : username.hashCode) +
        (identityToken == null ? 0 : identityToken.hashCode) +
        (refreshToken == null ? 0 : refreshToken.hashCode) +
        globalLogout.hashCode;

  factory DeviceBoundRequestPayload.fromJson(Map<String, dynamic> json) => _$DeviceBoundRequestPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBoundRequestPayloadToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


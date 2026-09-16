//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/user_info_passkey_credential_response.dart';
import 'package:doa_device_binding_api/src/model/external_oidc_provider.dart';
import 'package:doa_device_binding_api/src/model/user_info_biometric_credential_response.dart';
import 'package:doa_device_binding_api/src/model/user_info_linked_authentication_response.dart';
import 'package:doa_device_binding_api/src/model/user_registration_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_info_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserInfoResponse {
  /// Returns a new [UserInfoResponse] instance.
  UserInfoResponse({

     this.id,

     this.linkedAuthenticationMethods,

     this.linkedAuthentications,

     this.registrationStatus,

     this.passkeyCredentials,

     this.biometricCredentials,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



  @JsonKey(
    
    name: r'linkedAuthenticationMethods',
    required: false,
    includeIfNull: false,
  )


  final List<ExternalOidcProvider>? linkedAuthenticationMethods;



  @JsonKey(
    
    name: r'linkedAuthentications',
    required: false,
    includeIfNull: false,
  )


  final List<UserInfoLinkedAuthenticationResponse>? linkedAuthentications;



  @JsonKey(
    
    name: r'registrationStatus',
    required: false,
    includeIfNull: false,
  )


  final UserRegistrationStatus? registrationStatus;



  @JsonKey(
    
    name: r'passkeyCredentials',
    required: false,
    includeIfNull: false,
  )


  final List<UserInfoPasskeyCredentialResponse>? passkeyCredentials;



  @JsonKey(
    
    name: r'biometricCredentials',
    required: false,
    includeIfNull: false,
  )


  final List<UserInfoBiometricCredentialResponse>? biometricCredentials;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserInfoResponse &&
      other.id == id &&
      other.linkedAuthenticationMethods == linkedAuthenticationMethods &&
      other.linkedAuthentications == linkedAuthentications &&
      other.registrationStatus == registrationStatus &&
      other.passkeyCredentials == passkeyCredentials &&
      other.biometricCredentials == biometricCredentials;

    @override
    int get hashCode =>
        id.hashCode +
        (linkedAuthenticationMethods == null ? 0 : linkedAuthenticationMethods.hashCode) +
        (linkedAuthentications == null ? 0 : linkedAuthentications.hashCode) +
        registrationStatus.hashCode +
        (passkeyCredentials == null ? 0 : passkeyCredentials.hashCode) +
        (biometricCredentials == null ? 0 : biometricCredentials.hashCode);

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) => _$UserInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/device_attestation_dto.dart';
import 'package:doa_device_binding_api/src/model/user_device_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_passkeys_registration_verify_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingPasskeysRegistrationVerifyRequest {
  /// Returns a new [DeviceBindingPasskeysRegistrationVerifyRequest] instance.
  DeviceBindingPasskeysRegistrationVerifyRequest({

     this.language,

     this.roleKey,

     this.licenseKey,

    required  this.passkeyAttestation,

    required  this.identifier,

    required  this.deviceAttestation,

    required  this.requestChallenge,

     this.iosHardwareKey,

     this.androidIntegrityToken,

     this.deviceData,

    required  this.loginScope,
  });

      /// Language (used for communication). Currently only 'de' or 'en' is supported. Default: 'de'.
  @JsonKey(
    
    name: r'language',
    required: false,
    includeIfNull: false,
  )


  final String? language;



      /// Key of the role to assign to the user.
  @JsonKey(
    
    name: r'roleKey',
    required: false,
    includeIfNull: false,
  )


  final String? roleKey;



      /// Key of the license to assign to the user.
  @JsonKey(
    
    name: r'licenseKey',
    required: false,
    includeIfNull: false,
  )


  final String? licenseKey;



  @JsonKey(
    
    name: r'passkeyAttestation',
    required: true,
    includeIfNull: true,
  )


  final String? passkeyAttestation;



  @JsonKey(
    
    name: r'identifier',
    required: true,
    includeIfNull: true,
  )


  final String? identifier;



  @JsonKey(
    
    name: r'deviceAttestation',
    required: true,
    includeIfNull: false,
  )


  final DeviceAttestationDto deviceAttestation;



      /// Request challenge as received via challenge API.
  @JsonKey(
    
    name: r'requestChallenge',
    required: true,
    includeIfNull: true,
  )


  final String? requestChallenge;



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



  @JsonKey(
    
    name: r'loginScope',
    required: true,
    includeIfNull: true,
  )


  final String? loginScope;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingPasskeysRegistrationVerifyRequest &&
      other.language == language &&
      other.roleKey == roleKey &&
      other.licenseKey == licenseKey &&
      other.passkeyAttestation == passkeyAttestation &&
      other.identifier == identifier &&
      other.deviceAttestation == deviceAttestation &&
      other.requestChallenge == requestChallenge &&
      other.iosHardwareKey == iosHardwareKey &&
      other.androidIntegrityToken == androidIntegrityToken &&
      other.deviceData == deviceData &&
      other.loginScope == loginScope;

    @override
    int get hashCode =>
        (language == null ? 0 : language.hashCode) +
        (roleKey == null ? 0 : roleKey.hashCode) +
        (licenseKey == null ? 0 : licenseKey.hashCode) +
        (passkeyAttestation == null ? 0 : passkeyAttestation.hashCode) +
        (identifier == null ? 0 : identifier.hashCode) +
        deviceAttestation.hashCode +
        (requestChallenge == null ? 0 : requestChallenge.hashCode) +
        (iosHardwareKey == null ? 0 : iosHardwareKey.hashCode) +
        (androidIntegrityToken == null ? 0 : androidIntegrityToken.hashCode) +
        deviceData.hashCode +
        (loginScope == null ? 0 : loginScope.hashCode);

  factory DeviceBindingPasskeysRegistrationVerifyRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingPasskeysRegistrationVerifyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingPasskeysRegistrationVerifyRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


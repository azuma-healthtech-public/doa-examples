//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/device_attestation_dto.dart';
import 'package:doa_device_binding_api/src/model/user_device_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_register_health_id_account_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingRegisterHealthIdAccountRequest {
  /// Returns a new [DeviceBindingRegisterHealthIdAccountRequest] instance.
  DeviceBindingRegisterHealthIdAccountRequest({

     this.language,

     this.roleKey,

     this.licenseKey,

     this.identityToken,

    required  this.deviceAttestation,

    required  this.requestChallenge,

     this.iosHardwareKey,

     this.androidIntegrityToken,

     this.deviceData,
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



      /// Identity token used for registration.
  @JsonKey(
    
    name: r'identityToken',
    required: false,
    includeIfNull: false,
  )


  final String? identityToken;



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





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingRegisterHealthIdAccountRequest &&
      other.language == language &&
      other.roleKey == roleKey &&
      other.licenseKey == licenseKey &&
      other.identityToken == identityToken &&
      other.deviceAttestation == deviceAttestation &&
      other.requestChallenge == requestChallenge &&
      other.iosHardwareKey == iosHardwareKey &&
      other.androidIntegrityToken == androidIntegrityToken &&
      other.deviceData == deviceData;

    @override
    int get hashCode =>
        (language == null ? 0 : language.hashCode) +
        (roleKey == null ? 0 : roleKey.hashCode) +
        (licenseKey == null ? 0 : licenseKey.hashCode) +
        (identityToken == null ? 0 : identityToken.hashCode) +
        deviceAttestation.hashCode +
        (requestChallenge == null ? 0 : requestChallenge.hashCode) +
        (iosHardwareKey == null ? 0 : iosHardwareKey.hashCode) +
        (androidIntegrityToken == null ? 0 : androidIntegrityToken.hashCode) +
        deviceData.hashCode;

  factory DeviceBindingRegisterHealthIdAccountRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingRegisterHealthIdAccountRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingRegisterHealthIdAccountRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


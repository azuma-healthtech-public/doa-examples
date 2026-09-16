//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/user_device_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_biometrics_link_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingBiometricsLinkRequest {
  /// Returns a new [DeviceBindingBiometricsLinkRequest] instance.
  DeviceBindingBiometricsLinkRequest({

    required  this.id,

    required  this.accessToken,

    required  this.publicKey,

     this.deviceData,

    required  this.requestChallenge,

    required  this.requestSignature,
  });

      /// Account ID.
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: true,
  )


  final String? id;



      /// doa Access Token.
  @JsonKey(
    
    name: r'accessToken',
    required: true,
    includeIfNull: true,
  )


  final String? accessToken;



      /// Base64-encoded SubjectPublicKeyInfo (DER) of the device's biometric public key. Accepted algorithms:  - RSA-2048 (RSASSA-PKCS1-v1_5 with SHA-256)  - EC P-256 (ECDSA with SHA-256; signatures must be RFC 3279 DER SEQUENCE { r, s })
  @JsonKey(
    
    name: r'publicKey',
    required: true,
    includeIfNull: true,
  )


  final String? publicKey;



  @JsonKey(
    
    name: r'deviceData',
    required: false,
    includeIfNull: false,
  )


  final UserDeviceData? deviceData;



      /// Request challenge as received via challenge API.
  @JsonKey(
    
    name: r'requestChallenge',
    required: true,
    includeIfNull: true,
  )


  final String? requestChallenge;



      /// Base64-encoded signature of UTF-8(RequestChallenge). Algorithm must match the supplied PublicKey: RSASSA-PKCS1-v1_5(SHA-256) for RSA, or ECDSA(SHA-256, RFC 3279 DER) for EC P-256.
  @JsonKey(
    
    name: r'requestSignature',
    required: true,
    includeIfNull: true,
  )


  final String? requestSignature;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingBiometricsLinkRequest &&
      other.id == id &&
      other.accessToken == accessToken &&
      other.publicKey == publicKey &&
      other.deviceData == deviceData &&
      other.requestChallenge == requestChallenge &&
      other.requestSignature == requestSignature;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        (accessToken == null ? 0 : accessToken.hashCode) +
        (publicKey == null ? 0 : publicKey.hashCode) +
        deviceData.hashCode +
        (requestChallenge == null ? 0 : requestChallenge.hashCode) +
        (requestSignature == null ? 0 : requestSignature.hashCode);

  factory DeviceBindingBiometricsLinkRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingBiometricsLinkRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingBiometricsLinkRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


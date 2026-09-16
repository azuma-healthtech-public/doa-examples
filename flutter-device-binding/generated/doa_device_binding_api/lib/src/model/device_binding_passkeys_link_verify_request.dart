//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_passkeys_link_verify_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingPasskeysLinkVerifyRequest {
  /// Returns a new [DeviceBindingPasskeysLinkVerifyRequest] instance.
  DeviceBindingPasskeysLinkVerifyRequest({

    required  this.id,

    required  this.accessToken,

    required  this.passkeyAttestation,
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



      /// Attestation to create new passkey.
  @JsonKey(
    
    name: r'passkeyAttestation',
    required: true,
    includeIfNull: true,
  )


  final String? passkeyAttestation;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingPasskeysLinkVerifyRequest &&
      other.id == id &&
      other.accessToken == accessToken &&
      other.passkeyAttestation == passkeyAttestation;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        (accessToken == null ? 0 : accessToken.hashCode) +
        (passkeyAttestation == null ? 0 : passkeyAttestation.hashCode);

  factory DeviceBindingPasskeysLinkVerifyRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingPasskeysLinkVerifyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingPasskeysLinkVerifyRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


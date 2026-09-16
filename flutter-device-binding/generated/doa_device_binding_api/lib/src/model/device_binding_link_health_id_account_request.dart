//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_link_health_id_account_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingLinkHealthIdAccountRequest {
  /// Returns a new [DeviceBindingLinkHealthIdAccountRequest] instance.
  DeviceBindingLinkHealthIdAccountRequest({

     this.id,

     this.accessToken,

     this.healthIdIdentityToken,
  });

      /// Account ID.
  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



      /// doa Access Token.
  @JsonKey(
    
    name: r'accessToken',
    required: false,
    includeIfNull: false,
  )


  final String? accessToken;



      /// Identity token from mimoto.
  @JsonKey(
    
    name: r'healthIdIdentityToken',
    required: false,
    includeIfNull: false,
  )


  final String? healthIdIdentityToken;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingLinkHealthIdAccountRequest &&
      other.id == id &&
      other.accessToken == accessToken &&
      other.healthIdIdentityToken == healthIdIdentityToken;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        (accessToken == null ? 0 : accessToken.hashCode) +
        (healthIdIdentityToken == null ? 0 : healthIdIdentityToken.hashCode);

  factory DeviceBindingLinkHealthIdAccountRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingLinkHealthIdAccountRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingLinkHealthIdAccountRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


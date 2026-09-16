//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_passkeys_link_options_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingPasskeysLinkOptionsRequest {
  /// Returns a new [DeviceBindingPasskeysLinkOptionsRequest] instance.
  DeviceBindingPasskeysLinkOptionsRequest({

    required  this.id,

    required  this.accessToken,
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





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingPasskeysLinkOptionsRequest &&
      other.id == id &&
      other.accessToken == accessToken;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        (accessToken == null ? 0 : accessToken.hashCode);

  factory DeviceBindingPasskeysLinkOptionsRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingPasskeysLinkOptionsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingPasskeysLinkOptionsRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


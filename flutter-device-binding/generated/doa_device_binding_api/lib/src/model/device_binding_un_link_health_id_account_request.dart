//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_un_link_health_id_account_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingUnLinkHealthIdAccountRequest {
  /// Returns a new [DeviceBindingUnLinkHealthIdAccountRequest] instance.
  DeviceBindingUnLinkHealthIdAccountRequest({

     this.id,

     this.accessToken,
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





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingUnLinkHealthIdAccountRequest &&
      other.id == id &&
      other.accessToken == accessToken;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        (accessToken == null ? 0 : accessToken.hashCode);

  factory DeviceBindingUnLinkHealthIdAccountRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingUnLinkHealthIdAccountRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingUnLinkHealthIdAccountRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


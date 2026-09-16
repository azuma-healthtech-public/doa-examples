//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_biometrics_unlink_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingBiometricsUnlinkRequest {
  /// Returns a new [DeviceBindingBiometricsUnlinkRequest] instance.
  DeviceBindingBiometricsUnlinkRequest({

    required  this.id,

    required  this.accessToken,

    required  this.biometricsId,
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



      /// ID of the biometric credentials. All biometric credentials can be retrieved via /deviceBinding/account/v1/mobile/{applicationId}/userInfo.
  @JsonKey(
    
    name: r'biometricsId',
    required: true,
    includeIfNull: true,
  )


  final String? biometricsId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingBiometricsUnlinkRequest &&
      other.id == id &&
      other.accessToken == accessToken &&
      other.biometricsId == biometricsId;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        (accessToken == null ? 0 : accessToken.hashCode) +
        (biometricsId == null ? 0 : biometricsId.hashCode);

  factory DeviceBindingBiometricsUnlinkRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingBiometricsUnlinkRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingBiometricsUnlinkRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


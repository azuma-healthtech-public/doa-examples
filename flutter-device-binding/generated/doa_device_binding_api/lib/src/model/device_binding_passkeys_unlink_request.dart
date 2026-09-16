//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_passkeys_unlink_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingPasskeysUnlinkRequest {
  /// Returns a new [DeviceBindingPasskeysUnlinkRequest] instance.
  DeviceBindingPasskeysUnlinkRequest({

    required  this.id,

    required  this.accessToken,

    required  this.passkeyId,
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



      /// ID of the passkey credentials. All passkey credentials can be retrieved via /deviceBinding/account/v1/mobile/{applicationId}/userInfo.
  @JsonKey(
    
    name: r'passkeyId',
    required: true,
    includeIfNull: false,
  )


  final String passkeyId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingPasskeysUnlinkRequest &&
      other.id == id &&
      other.accessToken == accessToken &&
      other.passkeyId == passkeyId;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        (accessToken == null ? 0 : accessToken.hashCode) +
        passkeyId.hashCode;

  factory DeviceBindingPasskeysUnlinkRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingPasskeysUnlinkRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingPasskeysUnlinkRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


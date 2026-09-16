//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'global_logout_user_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GlobalLogoutUserRequest {
  /// Returns a new [GlobalLogoutUserRequest] instance.
  GlobalLogoutUserRequest({

     this.id,

     this.accessToken,

     this.refreshToken,

     this.clearNotUsedDeviceBindings,

     this.clearCurrentDeviceBinding,
  });

      /// User account ID.
  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



      /// Access token to be revoked.
  @JsonKey(
    
    name: r'accessToken',
    required: false,
    includeIfNull: false,
  )


  final String? accessToken;



      /// Refresh token to be revoked.
  @JsonKey(
    
    name: r'refreshToken',
    required: false,
    includeIfNull: false,
  )


  final String? refreshToken;



      /// If set to true, clears all device bindings (aparent from the currently used one). This will only work if AccessToken is valid!
  @JsonKey(
    
    name: r'clearNotUsedDeviceBindings',
    required: false,
    includeIfNull: false,
  )


  final bool? clearNotUsedDeviceBindings;



      /// If set to true, clears the currently used device binding. This will only work if AccessToken is valid!
  @JsonKey(
    
    name: r'clearCurrentDeviceBinding',
    required: false,
    includeIfNull: false,
  )


  final bool? clearCurrentDeviceBinding;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GlobalLogoutUserRequest &&
      other.id == id &&
      other.accessToken == accessToken &&
      other.refreshToken == refreshToken &&
      other.clearNotUsedDeviceBindings == clearNotUsedDeviceBindings &&
      other.clearCurrentDeviceBinding == clearCurrentDeviceBinding;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        (accessToken == null ? 0 : accessToken.hashCode) +
        (refreshToken == null ? 0 : refreshToken.hashCode) +
        clearNotUsedDeviceBindings.hashCode +
        clearCurrentDeviceBinding.hashCode;

  factory GlobalLogoutUserRequest.fromJson(Map<String, dynamic> json) => _$GlobalLogoutUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GlobalLogoutUserRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


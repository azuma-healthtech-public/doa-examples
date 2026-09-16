//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'logout_user_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LogoutUserRequest {
  /// Returns a new [LogoutUserRequest] instance.
  LogoutUserRequest({

     this.id,

     this.accessToken,

     this.refreshToken,

     this.globalLogout,
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



      /// If set to true, globally logs the user out. This will only work if AccessToken is valid!
  @JsonKey(
    
    name: r'globalLogout',
    required: false,
    includeIfNull: false,
  )


  final bool? globalLogout;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LogoutUserRequest &&
      other.id == id &&
      other.accessToken == accessToken &&
      other.refreshToken == refreshToken &&
      other.globalLogout == globalLogout;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        (accessToken == null ? 0 : accessToken.hashCode) +
        (refreshToken == null ? 0 : refreshToken.hashCode) +
        globalLogout.hashCode;

  factory LogoutUserRequest.fromJson(Map<String, dynamic> json) => _$LogoutUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LogoutUserRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


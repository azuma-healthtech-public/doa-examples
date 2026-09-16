//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/post_login_action.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RefreshTokenResponse {
  /// Returns a new [RefreshTokenResponse] instance.
  RefreshTokenResponse({

    required  this.accessToken,

    required  this.expiresIn,

     this.refreshToken,

    required  this.scope,

    required  this.tokenType,

    required  this.postLoginActions,
  });

  @JsonKey(
    
    name: r'accessToken',
    required: true,
    includeIfNull: true,
  )


  final String? accessToken;



  @JsonKey(
    
    name: r'expiresIn',
    required: true,
    includeIfNull: false,
  )


  final int expiresIn;



  @JsonKey(
    
    name: r'refreshToken',
    required: false,
    includeIfNull: false,
  )


  final String? refreshToken;



  @JsonKey(
    
    name: r'scope',
    required: true,
    includeIfNull: true,
  )


  final String? scope;



  @JsonKey(
    
    name: r'tokenType',
    required: true,
    includeIfNull: true,
  )


  final String? tokenType;



  @JsonKey(
    
    name: r'postLoginActions',
    required: true,
    includeIfNull: true,
  )


  final List<PostLoginAction>? postLoginActions;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RefreshTokenResponse &&
      other.accessToken == accessToken &&
      other.expiresIn == expiresIn &&
      other.refreshToken == refreshToken &&
      other.scope == scope &&
      other.tokenType == tokenType &&
      other.postLoginActions == postLoginActions;

    @override
    int get hashCode =>
        (accessToken == null ? 0 : accessToken.hashCode) +
        expiresIn.hashCode +
        (refreshToken == null ? 0 : refreshToken.hashCode) +
        (scope == null ? 0 : scope.hashCode) +
        (tokenType == null ? 0 : tokenType.hashCode) +
        (postLoginActions == null ? 0 : postLoginActions.hashCode);

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) => _$RefreshTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


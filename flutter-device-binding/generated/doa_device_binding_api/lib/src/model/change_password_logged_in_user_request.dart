//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'change_password_logged_in_user_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ChangePasswordLoggedInUserRequest {
  /// Returns a new [ChangePasswordLoggedInUserRequest] instance.
  ChangePasswordLoggedInUserRequest({

     this.identifier,

     this.newPassword,

     this.oldPassword,

     this.accessToken,
  });

  @JsonKey(
    
    name: r'identifier',
    required: false,
    includeIfNull: false,
  )


  final String? identifier;



  @JsonKey(
    
    name: r'newPassword',
    required: false,
    includeIfNull: false,
  )


  final String? newPassword;



  @JsonKey(
    
    name: r'oldPassword',
    required: false,
    includeIfNull: false,
  )


  final String? oldPassword;



  @JsonKey(
    
    name: r'accessToken',
    required: false,
    includeIfNull: false,
  )


  final String? accessToken;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ChangePasswordLoggedInUserRequest &&
      other.identifier == identifier &&
      other.newPassword == newPassword &&
      other.oldPassword == oldPassword &&
      other.accessToken == accessToken;

    @override
    int get hashCode =>
        (identifier == null ? 0 : identifier.hashCode) +
        (newPassword == null ? 0 : newPassword.hashCode) +
        (oldPassword == null ? 0 : oldPassword.hashCode) +
        (accessToken == null ? 0 : accessToken.hashCode);

  factory ChangePasswordLoggedInUserRequest.fromJson(Map<String, dynamic> json) => _$ChangePasswordLoggedInUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordLoggedInUserRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


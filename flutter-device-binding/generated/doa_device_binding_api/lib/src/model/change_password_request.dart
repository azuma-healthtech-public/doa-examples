//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'change_password_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ChangePasswordRequest {
  /// Returns a new [ChangePasswordRequest] instance.
  ChangePasswordRequest({

     this.email,

     this.password,

     this.passwordChangeToken,

     this.passwordChangeId,
  });

  @JsonKey(
    
    name: r'email',
    required: false,
    includeIfNull: false,
  )


  final String? email;



  @JsonKey(
    
    name: r'password',
    required: false,
    includeIfNull: false,
  )


  final String? password;



  @JsonKey(
    
    name: r'passwordChangeToken',
    required: false,
    includeIfNull: false,
  )


  final String? passwordChangeToken;



  @JsonKey(
    
    name: r'passwordChangeId',
    required: false,
    includeIfNull: false,
  )


  final String? passwordChangeId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ChangePasswordRequest &&
      other.email == email &&
      other.password == password &&
      other.passwordChangeToken == passwordChangeToken &&
      other.passwordChangeId == passwordChangeId;

    @override
    int get hashCode =>
        (email == null ? 0 : email.hashCode) +
        (password == null ? 0 : password.hashCode) +
        (passwordChangeToken == null ? 0 : passwordChangeToken.hashCode) +
        (passwordChangeId == null ? 0 : passwordChangeId.hashCode);

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) => _$ChangePasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


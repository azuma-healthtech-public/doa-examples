//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'user_info_passkey_credential_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserInfoPasskeyCredentialResponse {
  /// Returns a new [UserInfoPasskeyCredentialResponse] instance.
  UserInfoPasskeyCredentialResponse({

     this.id,

     this.credentialId,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



  @JsonKey(
    
    name: r'credentialId',
    required: false,
    includeIfNull: false,
  )


  final String? credentialId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserInfoPasskeyCredentialResponse &&
      other.id == id &&
      other.credentialId == credentialId;

    @override
    int get hashCode =>
        id.hashCode +
        (credentialId == null ? 0 : credentialId.hashCode);

  factory UserInfoPasskeyCredentialResponse.fromJson(Map<String, dynamic> json) => _$UserInfoPasskeyCredentialResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoPasskeyCredentialResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


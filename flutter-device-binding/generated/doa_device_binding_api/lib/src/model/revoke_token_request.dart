//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'revoke_token_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RevokeTokenRequest {
  /// Returns a new [RevokeTokenRequest] instance.
  RevokeTokenRequest({

     this.id,

    required  this.token,
  });

      /// User account ID.
  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



      /// Access or refresh token to be revoked.
  @JsonKey(
    
    name: r'token',
    required: true,
    includeIfNull: true,
  )


  final String? token;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RevokeTokenRequest &&
      other.id == id &&
      other.token == token;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        (token == null ? 0 : token.hashCode);

  factory RevokeTokenRequest.fromJson(Map<String, dynamic> json) => _$RevokeTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RevokeTokenRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


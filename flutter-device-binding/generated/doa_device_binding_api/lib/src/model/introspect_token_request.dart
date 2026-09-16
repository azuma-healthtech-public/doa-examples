//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'introspect_token_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class IntrospectTokenRequest {
  /// Returns a new [IntrospectTokenRequest] instance.
  IntrospectTokenRequest({

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



      /// Access or refresh token for introspection.
  @JsonKey(
    
    name: r'token',
    required: true,
    includeIfNull: true,
  )


  final String? token;





    @override
    bool operator ==(Object other) => identical(this, other) || other is IntrospectTokenRequest &&
      other.id == id &&
      other.token == token;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        (token == null ? 0 : token.hashCode);

  factory IntrospectTokenRequest.fromJson(Map<String, dynamic> json) => _$IntrospectTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$IntrospectTokenRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


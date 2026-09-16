//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'introspect_token_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class IntrospectTokenResponse {
  /// Returns a new [IntrospectTokenResponse] instance.
  IntrospectTokenResponse({

    required  this.active,
  });

  @JsonKey(
    
    name: r'active',
    required: true,
    includeIfNull: false,
  )


  final bool active;





    @override
    bool operator ==(Object other) => identical(this, other) || other is IntrospectTokenResponse &&
      other.active == active;

    @override
    int get hashCode =>
        active.hashCode;

  factory IntrospectTokenResponse.fromJson(Map<String, dynamic> json) => _$IntrospectTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IntrospectTokenResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


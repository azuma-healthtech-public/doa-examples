//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RefreshTokenRequest {
  /// Returns a new [RefreshTokenRequest] instance.
  RefreshTokenRequest({

     this.id,

    required  this.refreshToken,

     this.requestChallenge,
  });

      /// User account ID.
  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



      /// Refresh token.
  @JsonKey(
    
    name: r'refreshToken',
    required: true,
    includeIfNull: true,
  )


  final String? refreshToken;



      /// Challenge as received via challenge API.
  @JsonKey(
    
    name: r'requestChallenge',
    required: false,
    includeIfNull: false,
  )


  final String? requestChallenge;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RefreshTokenRequest &&
      other.id == id &&
      other.refreshToken == refreshToken &&
      other.requestChallenge == requestChallenge;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        (refreshToken == null ? 0 : refreshToken.hashCode) +
        (requestChallenge == null ? 0 : requestChallenge.hashCode);

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) => _$RefreshTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


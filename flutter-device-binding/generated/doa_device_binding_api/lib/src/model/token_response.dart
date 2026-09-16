//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'token_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TokenResponse {
  /// Returns a new [TokenResponse] instance.
  TokenResponse({

     this.accessToken,

     this.tokenType,

     this.expiresInSeconds,

     this.refreshToken,

     this.scope,

     this.idToken,

     this.issued,

     this.issuedUtc,

     this.isStale,
  });

  @JsonKey(
    
    name: r'accessToken',
    required: false,
    includeIfNull: false,
  )


  final String? accessToken;



  @JsonKey(
    
    name: r'tokenType',
    required: false,
    includeIfNull: false,
  )


  final String? tokenType;



  @JsonKey(
    
    name: r'expiresInSeconds',
    required: false,
    includeIfNull: false,
  )


  final int? expiresInSeconds;



  @JsonKey(
    
    name: r'refreshToken',
    required: false,
    includeIfNull: false,
  )


  final String? refreshToken;



  @JsonKey(
    
    name: r'scope',
    required: false,
    includeIfNull: false,
  )


  final String? scope;



  @JsonKey(
    
    name: r'idToken',
    required: false,
    includeIfNull: false,
  )


  final String? idToken;



  @Deprecated('issued has been deprecated')
  @JsonKey(
    
    name: r'issued',
    required: false,
    includeIfNull: false,
  )


  final DateTime? issued;



  @JsonKey(
    
    name: r'issuedUtc',
    required: false,
    includeIfNull: false,
  )


  final DateTime? issuedUtc;



  @JsonKey(
    
    name: r'isStale',
    required: false,
    includeIfNull: false,
  )


  final bool? isStale;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TokenResponse &&
      other.accessToken == accessToken &&
      other.tokenType == tokenType &&
      other.expiresInSeconds == expiresInSeconds &&
      other.refreshToken == refreshToken &&
      other.scope == scope &&
      other.idToken == idToken &&
      other.issued == issued &&
      other.issuedUtc == issuedUtc &&
      other.isStale == isStale;

    @override
    int get hashCode =>
        (accessToken == null ? 0 : accessToken.hashCode) +
        (tokenType == null ? 0 : tokenType.hashCode) +
        (expiresInSeconds == null ? 0 : expiresInSeconds.hashCode) +
        (refreshToken == null ? 0 : refreshToken.hashCode) +
        (scope == null ? 0 : scope.hashCode) +
        (idToken == null ? 0 : idToken.hashCode) +
        issued.hashCode +
        issuedUtc.hashCode +
        isStale.hashCode;

  factory TokenResponse.fromJson(Map<String, dynamic> json) => _$TokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


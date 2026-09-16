//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'user_info_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserInfoRequest {
  /// Returns a new [UserInfoRequest] instance.
  UserInfoRequest({

     this.id,

     this.accessToken,
  });

      /// Account ID.
  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



      /// doa Access Token.
  @JsonKey(
    
    name: r'accessToken',
    required: false,
    includeIfNull: false,
  )


  final String? accessToken;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserInfoRequest &&
      other.id == id &&
      other.accessToken == accessToken;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        (accessToken == null ? 0 : accessToken.hashCode);

  factory UserInfoRequest.fromJson(Map<String, dynamic> json) => _$UserInfoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


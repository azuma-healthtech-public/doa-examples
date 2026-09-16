//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/external_oidc_provider.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_info_linked_authentication_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserInfoLinkedAuthenticationResponse {
  /// Returns a new [UserInfoLinkedAuthenticationResponse] instance.
  UserInfoLinkedAuthenticationResponse({

     this.provider,

     this.sub,
  });

  @JsonKey(
    
    name: r'provider',
    required: false,
    includeIfNull: false,
  )


  final ExternalOidcProvider? provider;



  @JsonKey(
    
    name: r'sub',
    required: false,
    includeIfNull: false,
  )


  final String? sub;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserInfoLinkedAuthenticationResponse &&
      other.provider == provider &&
      other.sub == sub;

    @override
    int get hashCode =>
        provider.hashCode +
        (sub == null ? 0 : sub.hashCode);

  factory UserInfoLinkedAuthenticationResponse.fromJson(Map<String, dynamic> json) => _$UserInfoLinkedAuthenticationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoLinkedAuthenticationResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


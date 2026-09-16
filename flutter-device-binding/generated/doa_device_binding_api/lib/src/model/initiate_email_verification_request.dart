//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'initiate_email_verification_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class InitiateEmailVerificationRequest {
  /// Returns a new [InitiateEmailVerificationRequest] instance.
  InitiateEmailVerificationRequest({

    required  this.email,
  });

      /// Email of the account.
  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: true,
  )


  final String? email;





    @override
    bool operator ==(Object other) => identical(this, other) || other is InitiateEmailVerificationRequest &&
      other.email == email;

    @override
    int get hashCode =>
        (email == null ? 0 : email.hashCode);

  factory InitiateEmailVerificationRequest.fromJson(Map<String, dynamic> json) => _$InitiateEmailVerificationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$InitiateEmailVerificationRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


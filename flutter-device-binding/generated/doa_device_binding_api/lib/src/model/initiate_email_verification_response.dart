//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'initiate_email_verification_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class InitiateEmailVerificationResponse {
  /// Returns a new [InitiateEmailVerificationResponse] instance.
  InitiateEmailVerificationResponse({

    required  this.verificationFlow,
  });

      /// Verification flow.
  @JsonKey(
    
    name: r'verificationFlow',
    required: true,
    includeIfNull: true,
  )


  final String? verificationFlow;





    @override
    bool operator ==(Object other) => identical(this, other) || other is InitiateEmailVerificationResponse &&
      other.verificationFlow == verificationFlow;

    @override
    int get hashCode =>
        (verificationFlow == null ? 0 : verificationFlow.hashCode);

  factory InitiateEmailVerificationResponse.fromJson(Map<String, dynamic> json) => _$InitiateEmailVerificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InitiateEmailVerificationResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


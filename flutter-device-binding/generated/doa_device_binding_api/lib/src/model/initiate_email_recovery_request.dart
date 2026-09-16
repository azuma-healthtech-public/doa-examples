//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'initiate_email_recovery_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class InitiateEmailRecoveryRequest {
  /// Returns a new [InitiateEmailRecoveryRequest] instance.
  InitiateEmailRecoveryRequest({

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
    bool operator ==(Object other) => identical(this, other) || other is InitiateEmailRecoveryRequest &&
      other.email == email;

    @override
    int get hashCode =>
        (email == null ? 0 : email.hashCode);

  factory InitiateEmailRecoveryRequest.fromJson(Map<String, dynamic> json) => _$InitiateEmailRecoveryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$InitiateEmailRecoveryRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'confirm_account_email_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConfirmAccountEmailRequest {
  /// Returns a new [ConfirmAccountEmailRequest] instance.
  ConfirmAccountEmailRequest({

    required  this.email,

    required  this.verificationFlow,

    required  this.verificationCode,
  });

      /// Email to be marked as verified.
  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: true,
  )


  final String? email;



      /// Verification flow.
  @JsonKey(
    
    name: r'verificationFlow',
    required: true,
    includeIfNull: true,
  )


  final String? verificationFlow;



      /// Verification code.
  @JsonKey(
    
    name: r'verificationCode',
    required: true,
    includeIfNull: true,
  )


  final String? verificationCode;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ConfirmAccountEmailRequest &&
      other.email == email &&
      other.verificationFlow == verificationFlow &&
      other.verificationCode == verificationCode;

    @override
    int get hashCode =>
        (email == null ? 0 : email.hashCode) +
        (verificationFlow == null ? 0 : verificationFlow.hashCode) +
        (verificationCode == null ? 0 : verificationCode.hashCode);

  factory ConfirmAccountEmailRequest.fromJson(Map<String, dynamic> json) => _$ConfirmAccountEmailRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmAccountEmailRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


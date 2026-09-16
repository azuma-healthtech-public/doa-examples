//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'confirm_email_recovery_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConfirmEmailRecoveryRequest {
  /// Returns a new [ConfirmEmailRecoveryRequest] instance.
  ConfirmEmailRecoveryRequest({

    required  this.email,

    required  this.recoveryFlow,

    required  this.recoveryCode,
  });

      /// Email of the account the recovery was initiated for.
  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: true,
  )


  final String? email;



      /// Recovery flow.
  @JsonKey(
    
    name: r'recoveryFlow',
    required: true,
    includeIfNull: true,
  )


  final String? recoveryFlow;



      /// Recovery code.
  @JsonKey(
    
    name: r'recoveryCode',
    required: true,
    includeIfNull: true,
  )


  final String? recoveryCode;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ConfirmEmailRecoveryRequest &&
      other.email == email &&
      other.recoveryFlow == recoveryFlow &&
      other.recoveryCode == recoveryCode;

    @override
    int get hashCode =>
        (email == null ? 0 : email.hashCode) +
        (recoveryFlow == null ? 0 : recoveryFlow.hashCode) +
        (recoveryCode == null ? 0 : recoveryCode.hashCode);

  factory ConfirmEmailRecoveryRequest.fromJson(Map<String, dynamic> json) => _$ConfirmEmailRecoveryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmEmailRecoveryRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'confirm_email_recovery_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConfirmEmailRecoveryResponse {
  /// Returns a new [ConfirmEmailRecoveryResponse] instance.
  ConfirmEmailRecoveryResponse({

     this.passwordChangeToken,

     this.passwordChangeId,
  });

  @JsonKey(
    
    name: r'passwordChangeToken',
    required: false,
    includeIfNull: false,
  )


  final String? passwordChangeToken;



  @JsonKey(
    
    name: r'passwordChangeId',
    required: false,
    includeIfNull: false,
  )


  final String? passwordChangeId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ConfirmEmailRecoveryResponse &&
      other.passwordChangeToken == passwordChangeToken &&
      other.passwordChangeId == passwordChangeId;

    @override
    int get hashCode =>
        (passwordChangeToken == null ? 0 : passwordChangeToken.hashCode) +
        (passwordChangeId == null ? 0 : passwordChangeId.hashCode);

  factory ConfirmEmailRecoveryResponse.fromJson(Map<String, dynamic> json) => _$ConfirmEmailRecoveryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmEmailRecoveryResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


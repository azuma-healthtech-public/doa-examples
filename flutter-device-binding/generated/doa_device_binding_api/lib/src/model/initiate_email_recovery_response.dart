//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'initiate_email_recovery_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class InitiateEmailRecoveryResponse {
  /// Returns a new [InitiateEmailRecoveryResponse] instance.
  InitiateEmailRecoveryResponse({

    required  this.recoveryFlow,
  });

  @JsonKey(
    
    name: r'recoveryFlow',
    required: true,
    includeIfNull: true,
  )


  final String? recoveryFlow;





    @override
    bool operator ==(Object other) => identical(this, other) || other is InitiateEmailRecoveryResponse &&
      other.recoveryFlow == recoveryFlow;

    @override
    int get hashCode =>
        (recoveryFlow == null ? 0 : recoveryFlow.hashCode);

  factory InitiateEmailRecoveryResponse.fromJson(Map<String, dynamic> json) => _$InitiateEmailRecoveryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InitiateEmailRecoveryResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


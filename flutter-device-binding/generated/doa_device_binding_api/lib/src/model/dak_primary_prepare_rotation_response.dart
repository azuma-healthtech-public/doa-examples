//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'dak_primary_prepare_rotation_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DakPrimaryPrepareRotationResponse {
  /// Returns a new [DakPrimaryPrepareRotationResponse] instance.
  DakPrimaryPrepareRotationResponse({

     this.deviceAttestationKey,
  });

  @JsonKey(
    
    name: r'deviceAttestationKey',
    required: false,
    includeIfNull: false,
  )


  final String? deviceAttestationKey;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DakPrimaryPrepareRotationResponse &&
      other.deviceAttestationKey == deviceAttestationKey;

    @override
    int get hashCode =>
        (deviceAttestationKey == null ? 0 : deviceAttestationKey.hashCode);

  factory DakPrimaryPrepareRotationResponse.fromJson(Map<String, dynamic> json) => _$DakPrimaryPrepareRotationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DakPrimaryPrepareRotationResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


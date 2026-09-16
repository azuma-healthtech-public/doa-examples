//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'dak_primary_prepare_rotation_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DakPrimaryPrepareRotationRequest {
  /// Returns a new [DakPrimaryPrepareRotationRequest] instance.
  DakPrimaryPrepareRotationRequest({

     this.accessToken,
  });

  @JsonKey(
    
    name: r'accessToken',
    required: false,
    includeIfNull: false,
  )


  final String? accessToken;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DakPrimaryPrepareRotationRequest &&
      other.accessToken == accessToken;

    @override
    int get hashCode =>
        (accessToken == null ? 0 : accessToken.hashCode);

  factory DakPrimaryPrepareRotationRequest.fromJson(Map<String, dynamic> json) => _$DakPrimaryPrepareRotationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DakPrimaryPrepareRotationRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


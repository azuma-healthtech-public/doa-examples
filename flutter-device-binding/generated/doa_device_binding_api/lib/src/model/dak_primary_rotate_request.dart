//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'dak_primary_rotate_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DakPrimaryRotateRequest {
  /// Returns a new [DakPrimaryRotateRequest] instance.
  DakPrimaryRotateRequest({

     this.accessToken,

     this.deviceAttestationKey,
  });

  @JsonKey(
    
    name: r'accessToken',
    required: false,
    includeIfNull: false,
  )


  final String? accessToken;



  @JsonKey(
    
    name: r'deviceAttestationKey',
    required: false,
    includeIfNull: false,
  )


  final String? deviceAttestationKey;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DakPrimaryRotateRequest &&
      other.accessToken == accessToken &&
      other.deviceAttestationKey == deviceAttestationKey;

    @override
    int get hashCode =>
        (accessToken == null ? 0 : accessToken.hashCode) +
        (deviceAttestationKey == null ? 0 : deviceAttestationKey.hashCode);

  factory DakPrimaryRotateRequest.fromJson(Map<String, dynamic> json) => _$DakPrimaryRotateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DakPrimaryRotateRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


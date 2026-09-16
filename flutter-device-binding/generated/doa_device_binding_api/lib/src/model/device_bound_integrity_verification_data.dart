//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_bound_integrity_verification_data.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBoundIntegrityVerificationData {
  /// Returns a new [DeviceBoundIntegrityVerificationData] instance.
  DeviceBoundIntegrityVerificationData({

     this.challenge,

     this.androidIntegrityToken,
  });

  @JsonKey(
    
    name: r'challenge',
    required: false,
    includeIfNull: false,
  )


  final String? challenge;



  @JsonKey(
    
    name: r'androidIntegrityToken',
    required: false,
    includeIfNull: false,
  )


  final String? androidIntegrityToken;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBoundIntegrityVerificationData &&
      other.challenge == challenge &&
      other.androidIntegrityToken == androidIntegrityToken;

    @override
    int get hashCode =>
        (challenge == null ? 0 : challenge.hashCode) +
        (androidIntegrityToken == null ? 0 : androidIntegrityToken.hashCode);

  factory DeviceBoundIntegrityVerificationData.fromJson(Map<String, dynamic> json) => _$DeviceBoundIntegrityVerificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBoundIntegrityVerificationDataToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


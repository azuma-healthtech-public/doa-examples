//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'challenge_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ChallengeResponse {
  /// Returns a new [ChallengeResponse] instance.
  ChallengeResponse({

    required  this.challenge,
  });

  @JsonKey(
    
    name: r'challenge',
    required: true,
    includeIfNull: true,
  )


  final String? challenge;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ChallengeResponse &&
      other.challenge == challenge;

    @override
    int get hashCode =>
        (challenge == null ? 0 : challenge.hashCode);

  factory ChallengeResponse.fromJson(Map<String, dynamic> json) => _$ChallengeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


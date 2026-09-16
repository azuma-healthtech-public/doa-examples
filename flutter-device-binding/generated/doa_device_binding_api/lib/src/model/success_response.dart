//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'success_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SuccessResponse {
  /// Returns a new [SuccessResponse] instance.
  SuccessResponse({

    required  this.success,
  });

      /// Always true for now.
  @JsonKey(
    
    name: r'success',
    required: true,
    includeIfNull: false,
  )


  final bool success;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SuccessResponse &&
      other.success == success;

    @override
    int get hashCode =>
        success.hashCode;

  factory SuccessResponse.fromJson(Map<String, dynamic> json) => _$SuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SuccessResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


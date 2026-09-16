//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/business_error_codes.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error_dto.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ErrorDto {
  /// Returns a new [ErrorDto] instance.
  ErrorDto({

     this.error,

     this.errorDescription,

     this.errorData,
  });

  @JsonKey(
    
    name: r'error',
    required: false,
    includeIfNull: false,
  )


  final BusinessErrorCodes? error;



      /// Description of the error in english.
  @JsonKey(
    
    name: r'error_description',
    required: false,
    includeIfNull: false,
  )


  final String? errorDescription;



      /// Additional error data for some specific errors.     <div><b>RegistrationPasswordValidationFailed</b> example:          <pre>{\"error\":\"RegistrationPasswordValidationFailed\",\"error_description\":\"Password does not fulfill the requirements.\",\"error_data\":[\"FailedLength\",\"FailedDigit\"]}.</pre>         The following sub error codes are possible:         <ul><li>FailedBadList</li><li>FailedDigit</li><li>FailedLength</li><li>FailedLowercase</li><li>FailedUnique</li><li>FailedUppercase</li><li>FailedPunctuation</li><li>FailedRepeat</li><li>FailedPattern</li><li>FailedEntropy</li></ul></div>
  @JsonKey(
    
    name: r'error_data',
    required: false,
    includeIfNull: false,
  )


  final Object? errorData;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ErrorDto &&
      other.error == error &&
      other.errorDescription == errorDescription &&
      other.errorData == errorData;

    @override
    int get hashCode =>
        error.hashCode +
        (errorDescription == null ? 0 : errorDescription.hashCode) +
        (errorData == null ? 0 : errorData.hashCode);

  factory ErrorDto.fromJson(Map<String, dynamic> json) => _$ErrorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


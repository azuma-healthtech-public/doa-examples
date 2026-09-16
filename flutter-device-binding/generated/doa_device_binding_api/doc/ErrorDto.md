# doa_device_binding_api.model.ErrorDto

## Load the model package
```dart
import 'package:doa_device_binding_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**error** | [**BusinessErrorCodes**](BusinessErrorCodes.md) |  | [optional] 
**errorDescription** | **String** | Description of the error in english. | [optional] 
**errorData** | **Object** | Additional error data for some specific errors.     <div><b>RegistrationPasswordValidationFailed</b> example:          <pre>{\"error\":\"RegistrationPasswordValidationFailed\",\"error_description\":\"Password does not fulfill the requirements.\",\"error_data\":[\"FailedLength\",\"FailedDigit\"]}.</pre>         The following sub error codes are possible:         <ul><li>FailedBadList</li><li>FailedDigit</li><li>FailedLength</li><li>FailedLowercase</li><li>FailedUnique</li><li>FailedUppercase</li><li>FailedPunctuation</li><li>FailedRepeat</li><li>FailedPattern</li><li>FailedEntropy</li></ul></div> | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



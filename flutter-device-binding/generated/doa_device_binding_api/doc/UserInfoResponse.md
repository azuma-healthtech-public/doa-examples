# doa_device_binding_api.model.UserInfoResponse

## Load the model package
```dart
import 'package:doa_device_binding_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | [optional] 
**linkedAuthenticationMethods** | [**List&lt;ExternalOidcProvider&gt;**](ExternalOidcProvider.md) |  | [optional] 
**linkedAuthentications** | [**List&lt;UserInfoLinkedAuthenticationResponse&gt;**](UserInfoLinkedAuthenticationResponse.md) |  | [optional] 
**registrationStatus** | [**UserRegistrationStatus**](UserRegistrationStatus.md) |  | [optional] 
**passkeyCredentials** | [**List&lt;UserInfoPasskeyCredentialResponse&gt;**](UserInfoPasskeyCredentialResponse.md) |  | [optional] 
**biometricCredentials** | [**List&lt;UserInfoBiometricCredentialResponse&gt;**](UserInfoBiometricCredentialResponse.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



# doa_device_binding_api.model.LogoutUserRequest

## Load the model package
```dart
import 'package:doa_device_binding_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | User account ID. | [optional] 
**accessToken** | **String** | Access token to be revoked. | [optional] 
**refreshToken** | **String** | Refresh token to be revoked. | [optional] 
**globalLogout** | **bool** | If set to true, globally logs the user out. This will only work if AccessToken is valid! | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



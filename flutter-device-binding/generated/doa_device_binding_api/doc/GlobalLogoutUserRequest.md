# doa_device_binding_api.model.GlobalLogoutUserRequest

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
**clearNotUsedDeviceBindings** | **bool** | If set to true, clears all device bindings (aparent from the currently used one). This will only work if AccessToken is valid! | [optional] 
**clearCurrentDeviceBinding** | **bool** | If set to true, clears the currently used device binding. This will only work if AccessToken is valid! | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



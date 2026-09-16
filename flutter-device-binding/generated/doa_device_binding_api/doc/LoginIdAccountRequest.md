# doa_device_binding_api.model.LoginIdAccountRequest

## Load the model package
```dart
import 'package:doa_device_binding_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**scope** | **String** | The following scopes are supported: - offline_access --> this is required to receive refresh token - permissions_app - licenses | [optional] 
**requestChallenge** | **String** | Challenge as received via challenge API. | [optional] 
**deviceData** | [**UserDeviceData**](UserDeviceData.md) |  | [optional] 
**id** | **String** |  | 
**deviceBoundIntegrityVerificationData** | [**DeviceBoundIntegrityVerificationData**](DeviceBoundIntegrityVerificationData.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



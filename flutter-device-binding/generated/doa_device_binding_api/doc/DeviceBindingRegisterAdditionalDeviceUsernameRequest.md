# doa_device_binding_api.model.DeviceBindingRegisterAdditionalDeviceUsernameRequest

## Load the model package
```dart
import 'package:doa_device_binding_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**password** | **String** |  | [optional] 
**scope** | **String** | The following scopes are supported: - offline_access --> this is required to receive refresh token - permissions_app - licenses | [optional] 
**requestChallenge** | **String** | Challenge as received via challenge API. | [optional] 
**deviceData** | [**UserDeviceData**](UserDeviceData.md) |  | [optional] 
**deviceAttestationKey** | **String** | Device AttestationKey of the created account. DAK can be used instead of Password if enabled | [optional] 
**username** | **String** |  | 
**deviceBoundIntegrityVerificationData** | [**DeviceBoundIntegrityVerificationData**](DeviceBoundIntegrityVerificationData.md) |  | [optional] 
**deviceAttestation** | [**DeviceAttestationDto**](DeviceAttestationDto.md) |  | 
**iosHardwareKey** | **String** | IOS only: hardware key. | [optional] 
**androidIntegrityToken** | **String** | Android only: integrity token. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



# doa_device_binding_api.model.DeviceBindingRegisterDevicePasskeysVerifyRequest

## Load the model package
```dart
import 'package:doa_device_binding_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**scope** | **String** | The following scopes are supported: - offline_access --> this is required to receive refresh token - permissions_app - licenses | [optional] 
**assertion** | **String** |  | 
**identifier** | **String** |  | [optional] 
**deviceBoundIntegrityVerificationData** | [**DeviceBoundIntegrityVerificationData**](DeviceBoundIntegrityVerificationData.md) |  | [optional] 
**requestChallenge** | **String** | Challenge as received via challenge API. | 
**deviceAttestation** | [**DeviceAttestationDto**](DeviceAttestationDto.md) |  | 
**iosHardwareKey** | **String** | IOS only: hardware key. | [optional] 
**androidIntegrityToken** | **String** | Android only: integrity token. | [optional] 
**deviceData** | [**UserDeviceData**](UserDeviceData.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



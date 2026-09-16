# doa_device_binding_api.model.DeviceBindingRegisterOidcAccountRequest

## Load the model package
```dart
import 'package:doa_device_binding_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**language** | **String** | Language (used for communication). Currently only 'de' or 'en' is supported. Default: 'de'. | [optional] 
**roleKey** | **String** | Key of the role to assign to the user. | [optional] 
**licenseKey** | **String** | Key of the license to assign to the user. | [optional] 
**identityToken** | **String** | Identity token used for registration. | [optional] 
**deviceAttestation** | [**DeviceAttestationDto**](DeviceAttestationDto.md) |  | 
**requestChallenge** | **String** | Request challenge as received via challenge API. | 
**iosHardwareKey** | **String** | IOS only: hardware key. | [optional] 
**androidIntegrityToken** | **String** | Android only: integrity token. | [optional] 
**deviceData** | [**UserDeviceData**](UserDeviceData.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



# doa_device_binding_api.model.DeviceBindingBiometricsLoginRequest

## Load the model package
```dart
import 'package:doa_device_binding_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | [optional] 
**requestSignature** | **String** | Base64-encoded signature of UTF-8(RequestChallenge). Algorithm must match the linked PublicKey: RSASSA-PKCS1-v1_5(SHA-256) for RSA-2048, or ECDSA(SHA-256, RFC 3279 DER) for EC P-256. | [optional] 
**requestChallenge** | **String** | Challenge as received via challenge API. | [optional] 
**scope** | **String** | The following scopes are supported: - offline_access --> this is required to receive refresh token - permissions_app - licenses | [optional] 
**deviceData** | [**UserDeviceData**](UserDeviceData.md) |  | [optional] 
**deviceBoundIntegrityVerificationData** | [**DeviceBoundIntegrityVerificationData**](DeviceBoundIntegrityVerificationData.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



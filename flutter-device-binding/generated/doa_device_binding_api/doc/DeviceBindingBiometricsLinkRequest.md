# doa_device_binding_api.model.DeviceBindingBiometricsLinkRequest

## Load the model package
```dart
import 'package:doa_device_binding_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Account ID. | 
**accessToken** | **String** | doa Access Token. | 
**publicKey** | **String** | Base64-encoded SubjectPublicKeyInfo (DER) of the device's biometric public key. Accepted algorithms:  - RSA-2048 (RSASSA-PKCS1-v1_5 with SHA-256)  - EC P-256 (ECDSA with SHA-256; signatures must be RFC 3279 DER SEQUENCE { r, s }) | 
**deviceData** | [**UserDeviceData**](UserDeviceData.md) |  | [optional] 
**requestChallenge** | **String** | Request challenge as received via challenge API. | 
**requestSignature** | **String** | Base64-encoded signature of UTF-8(RequestChallenge). Algorithm must match the supplied PublicKey: RSASSA-PKCS1-v1_5(SHA-256) for RSA, or ECDSA(SHA-256, RFC 3279 DER) for EC P-256. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



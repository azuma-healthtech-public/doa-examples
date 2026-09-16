# doa_device_binding_api.model.DeviceBoundRequestPayload

## Load the model package
```dart
import 'package:doa_device_binding_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**email** | **String** |  | 
**password** | **String** |  | [optional] 
**passwordChangeToken** | **String** |  | [optional] 
**passwordChangeId** | **String** |  | [optional] 
**identifier** | **String** |  | [optional] 
**newPassword** | **String** |  | [optional] 
**oldPassword** | **String** |  | [optional] 
**accessToken** | **String** | doa Access Token. | [optional] 
**verificationFlow** | **String** | Verification flow. | 
**verificationCode** | **String** | Verification code. | 
**recoveryFlow** | **String** | Recovery flow. | 
**recoveryCode** | **String** | Recovery code. | 
**deviceAttestationKey** | **String** | Device AttestationKey of the created account. DAK can be used instead of Password if enabled | [optional] 
**requestChallenge** | **String** | Challenge as received via challenge API. | [optional] 
**deviceData** | [**UserDeviceData**](UserDeviceData.md) |  | [optional] 
**deviceAttestation** | [**DeviceAttestationDto**](DeviceAttestationDto.md) |  | 
**iosHardwareKey** | **String** | IOS only: hardware key. | [optional] 
**androidIntegrityToken** | **String** | Android only: integrity token. | [optional] 
**id** | **String** | Account ID. | [optional] 
**healthIdIdentityToken** | **String** | Identity token from mimoto. | [optional] 
**token** | **String** | Access or refresh token to be revoked. | 
**scope** | **String** | The following scopes are supported: - offline_access --> this is required to receive refresh token - permissions_app - licenses | [optional] 
**deviceBoundIntegrityVerificationData** | [**DeviceBoundIntegrityVerificationData**](DeviceBoundIntegrityVerificationData.md) |  | [optional] 
**username** | **String** |  | 
**identityToken** | **String** |  | 
**refreshToken** | **String** | Refresh token. | 
**globalLogout** | **bool** | If set to true, globally logs the user out. This will only work if AccessToken is valid! | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



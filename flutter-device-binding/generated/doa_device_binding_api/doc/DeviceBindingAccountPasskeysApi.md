# doa_device_binding_api.api.DeviceBindingAccountPasskeysApi

## Load the API package
```dart
import 'package:doa_device_binding_api/api.dart';
```

All URIs are relative to *https://pie.azuma-health.tech/api/organization*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deviceBindingAccountLinkAccountPasskeysGenOptions**](DeviceBindingAccountPasskeysApi.md#devicebindingaccountlinkaccountpasskeysgenoptions) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/link/passkeys/generate-options | Link passkey to account - Generate options.
[**deviceBindingAccountLinkAccountPasskeysVerify**](DeviceBindingAccountPasskeysApi.md#devicebindingaccountlinkaccountpasskeysverify) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/link/passkeys/verify | Link passkey to account - Verify.
[**deviceBindingAccountRegisterAccountPasskeysGenOptions**](DeviceBindingAccountPasskeysApi.md#devicebindingaccountregisteraccountpasskeysgenoptions) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/register/passkeys/generate-options | Register account via passkey - Generate options.
[**deviceBindingAccountRegisterAccountPasskeysVerify**](DeviceBindingAccountPasskeysApi.md#devicebindingaccountregisteraccountpasskeysverify) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/register/passkeys/verify | Register account via passkey - Verify.
[**deviceBindingAccountUnlinkAccountPasskey**](DeviceBindingAccountPasskeysApi.md#devicebindingaccountunlinkaccountpasskey) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/unlink/passkeys | Unlink a passkey.


# **deviceBindingAccountLinkAccountPasskeysGenOptions**
> DeviceBindingPasskeysLinkOptionsResponse deviceBindingAccountLinkAccountPasskeysGenOptions(applicationId, deviceBoundRequest)

Link passkey to account - Generate options.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountPasskeysApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-DeviceBindingPasskeysLinkOptionsRequest\">DeviceBindingPasskeysLinkOptionsRequest</a>).

try {
    final response = api.deviceBindingAccountLinkAccountPasskeysGenOptions(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountPasskeysApi->deviceBindingAccountLinkAccountPasskeysGenOptions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-DeviceBindingPasskeysLinkOptionsRequest\">DeviceBindingPasskeysLinkOptionsRequest</a>). | [optional] 

### Return type

[**DeviceBindingPasskeysLinkOptionsResponse**](DeviceBindingPasskeysLinkOptionsResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAccountLinkAccountPasskeysVerify**
> SuccessResponse deviceBindingAccountLinkAccountPasskeysVerify(applicationId, deviceBoundRequest)

Link passkey to account - Verify.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountPasskeysApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-DeviceBindingPasskeysLinkVerifyRequest\">DeviceBindingPasskeysLinkVerifyRequest</a>).

try {
    final response = api.deviceBindingAccountLinkAccountPasskeysVerify(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountPasskeysApi->deviceBindingAccountLinkAccountPasskeysVerify: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-DeviceBindingPasskeysLinkVerifyRequest\">DeviceBindingPasskeysLinkVerifyRequest</a>). | [optional] 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAccountRegisterAccountPasskeysGenOptions**
> DeviceBindingPasskeysRegistrationOptionsResponse deviceBindingAccountRegisterAccountPasskeysGenOptions(applicationId, deviceBindingPasskeysRegistrationOptionsRequest)

Register account via passkey - Generate options.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountPasskeysApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBindingPasskeysRegistrationOptionsRequest deviceBindingPasskeysRegistrationOptionsRequest = ; // DeviceBindingPasskeysRegistrationOptionsRequest | Request payload.

try {
    final response = api.deviceBindingAccountRegisterAccountPasskeysGenOptions(applicationId, deviceBindingPasskeysRegistrationOptionsRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountPasskeysApi->deviceBindingAccountRegisterAccountPasskeysGenOptions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBindingPasskeysRegistrationOptionsRequest** | [**DeviceBindingPasskeysRegistrationOptionsRequest**](DeviceBindingPasskeysRegistrationOptionsRequest.md)| Request payload. | [optional] 

### Return type

[**DeviceBindingPasskeysRegistrationOptionsResponse**](DeviceBindingPasskeysRegistrationOptionsResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAccountRegisterAccountPasskeysVerify**
> DeviceBindingPasskeysRegistrationVerifyResponse deviceBindingAccountRegisterAccountPasskeysVerify(applicationId, deviceBindingPasskeysRegistrationVerifyRequest)

Register account via passkey - Verify.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountPasskeysApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBindingPasskeysRegistrationVerifyRequest deviceBindingPasskeysRegistrationVerifyRequest = ; // DeviceBindingPasskeysRegistrationVerifyRequest | Request payload.

try {
    final response = api.deviceBindingAccountRegisterAccountPasskeysVerify(applicationId, deviceBindingPasskeysRegistrationVerifyRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountPasskeysApi->deviceBindingAccountRegisterAccountPasskeysVerify: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBindingPasskeysRegistrationVerifyRequest** | [**DeviceBindingPasskeysRegistrationVerifyRequest**](DeviceBindingPasskeysRegistrationVerifyRequest.md)| Request payload. | [optional] 

### Return type

[**DeviceBindingPasskeysRegistrationVerifyResponse**](DeviceBindingPasskeysRegistrationVerifyResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAccountUnlinkAccountPasskey**
> SuccessResponse deviceBindingAccountUnlinkAccountPasskey(applicationId, deviceBoundRequest)

Unlink a passkey.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountPasskeysApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-DeviceBindingPasskeysUnlinkRequest\">DeviceBindingPasskeysUnlinkRequest</a>).

try {
    final response = api.deviceBindingAccountUnlinkAccountPasskey(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountPasskeysApi->deviceBindingAccountUnlinkAccountPasskey: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-DeviceBindingPasskeysUnlinkRequest\">DeviceBindingPasskeysUnlinkRequest</a>). | [optional] 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


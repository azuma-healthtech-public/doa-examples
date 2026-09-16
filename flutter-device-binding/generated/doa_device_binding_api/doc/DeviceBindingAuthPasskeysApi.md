# doa_device_binding_api.api.DeviceBindingAuthPasskeysApi

## Load the API package
```dart
import 'package:doa_device_binding_api/api.dart';
```

All URIs are relative to *https://pie.azuma-health.tech/api/organization*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deviceBindingAuthLoginPasskeyGenOptions**](DeviceBindingAuthPasskeysApi.md#devicebindingauthloginpasskeygenoptions) | **POST** /deviceBinding/auth/v1/mobile/{applicationId}/login/passkeys/generate-options | Login account via passkey - Generate options.
[**deviceBindingAuthLoginPasskeyVerify**](DeviceBindingAuthPasskeysApi.md#devicebindingauthloginpasskeyverify) | **POST** /deviceBinding/auth/v1/mobile/{applicationId}/login/passkeys/verify | Login account via passkey - Verify.


# **deviceBindingAuthLoginPasskeyGenOptions**
> DeviceBindingPasskeysLoginOptionsResponse deviceBindingAuthLoginPasskeyGenOptions(applicationId, deviceBoundRequest)

Login account via passkey - Generate options.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAuthPasskeysApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-DeviceBindingPasskeysLoginOptionsRequest\">DeviceBindingPasskeysLoginOptionsRequest</a>).

try {
    final response = api.deviceBindingAuthLoginPasskeyGenOptions(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAuthPasskeysApi->deviceBindingAuthLoginPasskeyGenOptions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-DeviceBindingPasskeysLoginOptionsRequest\">DeviceBindingPasskeysLoginOptionsRequest</a>). | [optional] 

### Return type

[**DeviceBindingPasskeysLoginOptionsResponse**](DeviceBindingPasskeysLoginOptionsResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAuthLoginPasskeyVerify**
> TokenResponse deviceBindingAuthLoginPasskeyVerify(applicationId, deviceBoundRequest)

Login account via passkey - Verify.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAuthPasskeysApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-DeviceBindingPasskeysLoginVerifyRequest\">DeviceBindingPasskeysLoginVerifyRequest</a>).

try {
    final response = api.deviceBindingAuthLoginPasskeyVerify(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAuthPasskeysApi->deviceBindingAuthLoginPasskeyVerify: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-DeviceBindingPasskeysLoginVerifyRequest\">DeviceBindingPasskeysLoginVerifyRequest</a>). | [optional] 

### Return type

[**TokenResponse**](TokenResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


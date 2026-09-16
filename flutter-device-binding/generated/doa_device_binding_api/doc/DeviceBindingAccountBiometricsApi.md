# doa_device_binding_api.api.DeviceBindingAccountBiometricsApi

## Load the API package
```dart
import 'package:doa_device_binding_api/api.dart';
```

All URIs are relative to *https://pie.azuma-health.tech/api/organization*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deviceBindingAccountLinkAccountBiometrics**](DeviceBindingAccountBiometricsApi.md#devicebindingaccountlinkaccountbiometrics) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/link/biometrics | Link biometrics to account.
[**deviceBindingAccountUnlinkAccountBiometrics**](DeviceBindingAccountBiometricsApi.md#devicebindingaccountunlinkaccountbiometrics) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/unlink/biometrics | Unlink biometrics.


# **deviceBindingAccountLinkAccountBiometrics**
> DeviceBindingPasskeysLinkOptionsResponse deviceBindingAccountLinkAccountBiometrics(applicationId, deviceBoundRequest)

Link biometrics to account.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountBiometricsApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-DeviceBindingBiometricsLinkRequest\">DeviceBindingBiometricsLinkRequest</a>).

try {
    final response = api.deviceBindingAccountLinkAccountBiometrics(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountBiometricsApi->deviceBindingAccountLinkAccountBiometrics: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-DeviceBindingBiometricsLinkRequest\">DeviceBindingBiometricsLinkRequest</a>). | [optional] 

### Return type

[**DeviceBindingPasskeysLinkOptionsResponse**](DeviceBindingPasskeysLinkOptionsResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAccountUnlinkAccountBiometrics**
> SuccessResponse deviceBindingAccountUnlinkAccountBiometrics(applicationId, deviceBoundRequest)

Unlink biometrics.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountBiometricsApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-DeviceBindingBiometricsUnlinkRequest\">DeviceBindingBiometricsUnlinkRequest</a>).

try {
    final response = api.deviceBindingAccountUnlinkAccountBiometrics(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountBiometricsApi->deviceBindingAccountUnlinkAccountBiometrics: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-DeviceBindingBiometricsUnlinkRequest\">DeviceBindingBiometricsUnlinkRequest</a>). | [optional] 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


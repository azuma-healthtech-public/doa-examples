# doa_device_binding_api.api.DeviceBindingAuthBiometricsApi

## Load the API package
```dart
import 'package:doa_device_binding_api/api.dart';
```

All URIs are relative to *https://pie.azuma-health.tech/api/organization*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deviceBindingAuthLoginBiometrics**](DeviceBindingAuthBiometricsApi.md#devicebindingauthloginbiometrics) | **POST** /deviceBinding/auth/v1/mobile/{applicationId}/login/biometrics | Login account via biometrics.


# **deviceBindingAuthLoginBiometrics**
> LoginResponse deviceBindingAuthLoginBiometrics(applicationId, deviceBoundRequest)

Login account via biometrics.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAuthBiometricsApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-DeviceBindingBiometricsLoginRequest\">DeviceBindingBiometricsLoginRequest</a>).

try {
    final response = api.deviceBindingAuthLoginBiometrics(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAuthBiometricsApi->deviceBindingAuthLoginBiometrics: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-DeviceBindingBiometricsLoginRequest\">DeviceBindingBiometricsLoginRequest</a>). | [optional] 

### Return type

[**LoginResponse**](LoginResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


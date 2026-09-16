# doa_device_binding_api.api.DeviceBindingAuthOIDCApi

## Load the API package
```dart
import 'package:doa_device_binding_api/api.dart';
```

All URIs are relative to *https://pie.azuma-health.tech/api/organization*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deviceBindingAuthLoginApple**](DeviceBindingAuthOIDCApi.md#devicebindingauthloginapple) | **POST** /deviceBinding/auth/v1/mobile/{applicationId}/login/apple | Login apple account via token exchange.
[**deviceBindingAuthLoginGoogle**](DeviceBindingAuthOIDCApi.md#devicebindingauthlogingoogle) | **POST** /deviceBinding/auth/v1/mobile/{applicationId}/login/google | Login google account via token exchange.


# **deviceBindingAuthLoginApple**
> LoginResponse deviceBindingAuthLoginApple(applicationId, deviceBoundRequest)

Login apple account via token exchange.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAuthOIDCApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-LoginOidcAccountRequest\">LoginOidcAccountRequest</a>).

try {
    final response = api.deviceBindingAuthLoginApple(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAuthOIDCApi->deviceBindingAuthLoginApple: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-LoginOidcAccountRequest\">LoginOidcAccountRequest</a>). | [optional] 

### Return type

[**LoginResponse**](LoginResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAuthLoginGoogle**
> LoginResponse deviceBindingAuthLoginGoogle(applicationId, deviceBoundRequest)

Login google account via token exchange.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAuthOIDCApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-LoginOidcAccountRequest\">LoginOidcAccountRequest</a>).

try {
    final response = api.deviceBindingAuthLoginGoogle(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAuthOIDCApi->deviceBindingAuthLoginGoogle: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-LoginOidcAccountRequest\">LoginOidcAccountRequest</a>). | [optional] 

### Return type

[**LoginResponse**](LoginResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


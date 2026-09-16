# doa_device_binding_api.api.DeviceBindingAuthHealthIDApi

## Load the API package
```dart
import 'package:doa_device_binding_api/api.dart';
```

All URIs are relative to *https://pie.azuma-health.tech/api/organization*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deviceBindingAuthLoginHealthId**](DeviceBindingAuthHealthIDApi.md#devicebindingauthloginhealthid) | **POST** /deviceBinding/auth/v1/mobile/{applicationId}/login/healthId | Login health-ID account.


# **deviceBindingAuthLoginHealthId**
> LoginResponse deviceBindingAuthLoginHealthId(applicationId, deviceBoundRequest)

Login health-ID account.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAuthHealthIDApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-LoginHealthIdAccountRequest\">LoginHealthIdAccountRequest</a>).

try {
    final response = api.deviceBindingAuthLoginHealthId(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAuthHealthIDApi->deviceBindingAuthLoginHealthId: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-LoginHealthIdAccountRequest\">LoginHealthIdAccountRequest</a>). | [optional] 

### Return type

[**LoginResponse**](LoginResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


# doa_device_binding_api.api.DeviceBindingSessionApi

## Load the API package
```dart
import 'package:doa_device_binding_api/api.dart';
```

All URIs are relative to *https://pie.azuma-health.tech/api/organization*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deviceBindingSessionIntrospectToken**](DeviceBindingSessionApi.md#devicebindingsessionintrospecttoken) | **POST** /deviceBinding/session/v1/mobile/{applicationId}/introspect | Introspect the given token.
[**deviceBindingSessionRevokeToken**](DeviceBindingSessionApi.md#devicebindingsessionrevoketoken) | **POST** /deviceBinding/session/v1/mobile/{applicationId}/revoke | Revoke the given token.


# **deviceBindingSessionIntrospectToken**
> IntrospectTokenResponse deviceBindingSessionIntrospectToken(applicationId, deviceBoundRequest)

Introspect the given token.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingSessionApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-IntrospectTokenRequest\">IntrospectTokenRequest</a>).

try {
    final response = api.deviceBindingSessionIntrospectToken(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingSessionApi->deviceBindingSessionIntrospectToken: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-IntrospectTokenRequest\">IntrospectTokenRequest</a>). | [optional] 

### Return type

[**IntrospectTokenResponse**](IntrospectTokenResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingSessionRevokeToken**
> SuccessResponse deviceBindingSessionRevokeToken(applicationId, deviceBoundRequest)

Revoke the given token.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingSessionApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-RevokeTokenRequest\">RevokeTokenRequest</a>).

try {
    final response = api.deviceBindingSessionRevokeToken(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingSessionApi->deviceBindingSessionRevokeToken: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-RevokeTokenRequest\">RevokeTokenRequest</a>). | [optional] 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


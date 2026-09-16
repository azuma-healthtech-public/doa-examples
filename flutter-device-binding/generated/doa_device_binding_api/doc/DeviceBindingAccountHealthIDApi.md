# doa_device_binding_api.api.DeviceBindingAccountHealthIDApi

## Load the API package
```dart
import 'package:doa_device_binding_api/api.dart';
```

All URIs are relative to *https://pie.azuma-health.tech/api/organization*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deviceBindingAccountLinkHealthId**](DeviceBindingAccountHealthIDApi.md#devicebindingaccountlinkhealthid) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/link/healthId | Link a health id account to the current account.
[**deviceBindingAccountRegisterAccountHealthId**](DeviceBindingAccountHealthIDApi.md#devicebindingaccountregisteraccounthealthid) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/register/healthId | Register a new health id account.
[**deviceBindingAccountUnlinkHealthId**](DeviceBindingAccountHealthIDApi.md#devicebindingaccountunlinkhealthid) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/unlink/healthId | Unlink a health id account to the current account.


# **deviceBindingAccountLinkHealthId**
> SuccessResponse deviceBindingAccountLinkHealthId(applicationId, deviceBoundRequest)

Link a health id account to the current account.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountHealthIDApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-DeviceBindingLinkHealthIdAccountRequest\">DeviceBindingLinkHealthIdAccountRequest</a>).

try {
    final response = api.deviceBindingAccountLinkHealthId(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountHealthIDApi->deviceBindingAccountLinkHealthId: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-DeviceBindingLinkHealthIdAccountRequest\">DeviceBindingLinkHealthIdAccountRequest</a>). | [optional] 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAccountRegisterAccountHealthId**
> DeviceBindingRegisterHealthIdAccountResponse deviceBindingAccountRegisterAccountHealthId(applicationId, deviceBindingRegisterHealthIdAccountRequest)

Register a new health id account.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountHealthIDApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBindingRegisterHealthIdAccountRequest deviceBindingRegisterHealthIdAccountRequest = ; // DeviceBindingRegisterHealthIdAccountRequest | Register account request data.

try {
    final response = api.deviceBindingAccountRegisterAccountHealthId(applicationId, deviceBindingRegisterHealthIdAccountRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountHealthIDApi->deviceBindingAccountRegisterAccountHealthId: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBindingRegisterHealthIdAccountRequest** | [**DeviceBindingRegisterHealthIdAccountRequest**](DeviceBindingRegisterHealthIdAccountRequest.md)| Register account request data. | [optional] 

### Return type

[**DeviceBindingRegisterHealthIdAccountResponse**](DeviceBindingRegisterHealthIdAccountResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAccountUnlinkHealthId**
> SuccessResponse deviceBindingAccountUnlinkHealthId(applicationId, deviceBoundRequest)

Unlink a health id account to the current account.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountHealthIDApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-DeviceBindingUnLinkHealthIdAccountRequest\">DeviceBindingUnLinkHealthIdAccountRequest</a>).

try {
    final response = api.deviceBindingAccountUnlinkHealthId(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountHealthIDApi->deviceBindingAccountUnlinkHealthId: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-DeviceBindingUnLinkHealthIdAccountRequest\">DeviceBindingUnLinkHealthIdAccountRequest</a>). | [optional] 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


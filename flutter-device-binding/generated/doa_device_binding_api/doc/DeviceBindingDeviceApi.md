# doa_device_binding_api.api.DeviceBindingDeviceApi

## Load the API package
```dart
import 'package:doa_device_binding_api/api.dart';
```

All URIs are relative to *https://pie.azuma-health.tech/api/organization*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deviceBindingDevicePreparePrimaryDakRotation**](DeviceBindingDeviceApi.md#devicebindingdeviceprepareprimarydakrotation) | **POST** /deviceBinding/device/v1/mobile/{applicationId}/dak/primary/prepare | Device attestation key: generate a new primary key, but dont activate yet.
[**deviceBindingDeviceRefreshBinding**](DeviceBindingDeviceApi.md#devicebindingdevicerefreshbinding) | **POST** /deviceBinding/device/v1/mobile/{applicationId}/refresh | Refresh device binding.
[**deviceBindingDeviceRegisterAdditionalViaEmail**](DeviceBindingDeviceApi.md#devicebindingdeviceregisteradditionalviaemail) | **POST** /deviceBinding/device/v1/mobile/{applicationId}/register/email | Register additional device for email account.
[**deviceBindingDeviceRegisterAdditionalViaUsername**](DeviceBindingDeviceApi.md#devicebindingdeviceregisteradditionalviausername) | **POST** /deviceBinding/device/v1/mobile/{applicationId}/register/username | Register  additional device for username account.
[**deviceBindingDeviceRotatePrimaryDak**](DeviceBindingDeviceApi.md#devicebindingdevicerotateprimarydak) | **POST** /deviceBinding/device/v1/mobile/{applicationId}/dak/primary/rotate | Device attestation key: activate the new primary key.


# **deviceBindingDevicePreparePrimaryDakRotation**
> DakPrimaryPrepareRotationResponse deviceBindingDevicePreparePrimaryDakRotation(applicationId, deviceBoundRequest)

Device attestation key: generate a new primary key, but dont activate yet.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingDeviceApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-DakPrimaryPrepareRotationRequest\">DakPrimaryPrepareRotationRequest</a>).

try {
    final response = api.deviceBindingDevicePreparePrimaryDakRotation(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingDeviceApi->deviceBindingDevicePreparePrimaryDakRotation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-DakPrimaryPrepareRotationRequest\">DakPrimaryPrepareRotationRequest</a>). | [optional] 

### Return type

[**DakPrimaryPrepareRotationResponse**](DakPrimaryPrepareRotationResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingDeviceRefreshBinding**
> SuccessResponse deviceBindingDeviceRefreshBinding(applicationId, deviceBoundRequest)

Refresh device binding.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingDeviceApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-DeviceBindingRefreshRequest\">DeviceBindingRefreshRequest</a>).

try {
    final response = api.deviceBindingDeviceRefreshBinding(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingDeviceApi->deviceBindingDeviceRefreshBinding: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-DeviceBindingRefreshRequest\">DeviceBindingRefreshRequest</a>). | [optional] 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingDeviceRegisterAdditionalViaEmail**
> LoginResponse deviceBindingDeviceRegisterAdditionalViaEmail(applicationId, deviceBindingRegisterAdditionalDeviceEmailRequest)

Register additional device for email account.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingDeviceApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBindingRegisterAdditionalDeviceEmailRequest deviceBindingRegisterAdditionalDeviceEmailRequest = ; // DeviceBindingRegisterAdditionalDeviceEmailRequest | Request payload.

try {
    final response = api.deviceBindingDeviceRegisterAdditionalViaEmail(applicationId, deviceBindingRegisterAdditionalDeviceEmailRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingDeviceApi->deviceBindingDeviceRegisterAdditionalViaEmail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBindingRegisterAdditionalDeviceEmailRequest** | [**DeviceBindingRegisterAdditionalDeviceEmailRequest**](DeviceBindingRegisterAdditionalDeviceEmailRequest.md)| Request payload. | [optional] 

### Return type

[**LoginResponse**](LoginResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingDeviceRegisterAdditionalViaUsername**
> LoginResponse deviceBindingDeviceRegisterAdditionalViaUsername(applicationId, deviceBindingRegisterAdditionalDeviceUsernameRequest)

Register  additional device for username account.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingDeviceApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBindingRegisterAdditionalDeviceUsernameRequest deviceBindingRegisterAdditionalDeviceUsernameRequest = ; // DeviceBindingRegisterAdditionalDeviceUsernameRequest | Request payload.

try {
    final response = api.deviceBindingDeviceRegisterAdditionalViaUsername(applicationId, deviceBindingRegisterAdditionalDeviceUsernameRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingDeviceApi->deviceBindingDeviceRegisterAdditionalViaUsername: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBindingRegisterAdditionalDeviceUsernameRequest** | [**DeviceBindingRegisterAdditionalDeviceUsernameRequest**](DeviceBindingRegisterAdditionalDeviceUsernameRequest.md)| Request payload. | [optional] 

### Return type

[**LoginResponse**](LoginResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingDeviceRotatePrimaryDak**
> SuccessResponse deviceBindingDeviceRotatePrimaryDak(applicationId, deviceBoundRequest)

Device attestation key: activate the new primary key.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingDeviceApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-DakPrimaryRotateRequest\">DakPrimaryRotateRequest</a>).

try {
    final response = api.deviceBindingDeviceRotatePrimaryDak(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingDeviceApi->deviceBindingDeviceRotatePrimaryDak: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-DakPrimaryRotateRequest\">DakPrimaryRotateRequest</a>). | [optional] 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


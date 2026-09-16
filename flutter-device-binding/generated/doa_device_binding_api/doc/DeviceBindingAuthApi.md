# doa_device_binding_api.api.DeviceBindingAuthApi

## Load the API package
```dart
import 'package:doa_device_binding_api/api.dart';
```

All URIs are relative to *https://pie.azuma-health.tech/api/organization*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deviceBindingAuthGlobalLogout**](DeviceBindingAuthApi.md#devicebindingauthgloballogout) | **POST** /deviceBinding/auth/v1/mobile/{applicationId}/global-logout | Global logout with optional device bindings removal.
[**deviceBindingAuthLogin**](DeviceBindingAuthApi.md#devicebindingauthlogin) | **POST** /deviceBinding/auth/v1/mobile/{applicationId}/login | Login account.
[**deviceBindingAuthLoginEmail**](DeviceBindingAuthApi.md#devicebindingauthloginemail) | **POST** /deviceBinding/auth/v1/mobile/{applicationId}/login/email | Login email account.
[**deviceBindingAuthLoginId**](DeviceBindingAuthApi.md#devicebindingauthloginid) | **POST** /deviceBinding/auth/v1/mobile/{applicationId}/login/id | Login account with ID.
[**deviceBindingAuthLoginUsername**](DeviceBindingAuthApi.md#devicebindingauthloginusername) | **POST** /deviceBinding/auth/v1/mobile/{applicationId}/login/username | Login username account.
[**deviceBindingAuthLogout**](DeviceBindingAuthApi.md#devicebindingauthlogout) | **POST** /deviceBinding/auth/v1/mobile/{applicationId}/logout | Logout.
[**deviceBindingAuthRefreshToken**](DeviceBindingAuthApi.md#devicebindingauthrefreshtoken) | **POST** /deviceBinding/auth/v1/mobile/{applicationId}/refresh | Refresh token.


# **deviceBindingAuthGlobalLogout**
> SuccessResponse deviceBindingAuthGlobalLogout(applicationId, deviceBoundRequest)

Global logout with optional device bindings removal.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAuthApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-LogoutUserRequest\">GlobalLogoutUserRequest</a>).

try {
    final response = api.deviceBindingAuthGlobalLogout(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAuthApi->deviceBindingAuthGlobalLogout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-LogoutUserRequest\">GlobalLogoutUserRequest</a>). | [optional] 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAuthLogin**
> LoginResponse deviceBindingAuthLogin(applicationId, deviceBoundRequest)

Login account.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAuthApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-LoginAccountRequest\">LoginAccountRequest</a>).

try {
    final response = api.deviceBindingAuthLogin(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAuthApi->deviceBindingAuthLogin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-LoginAccountRequest\">LoginAccountRequest</a>). | [optional] 

### Return type

[**LoginResponse**](LoginResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAuthLoginEmail**
> LoginResponse deviceBindingAuthLoginEmail(applicationId, deviceBoundRequest)

Login email account.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAuthApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-LoginEmailAccountRequest\">LoginEmailAccountRequest</a>).

try {
    final response = api.deviceBindingAuthLoginEmail(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAuthApi->deviceBindingAuthLoginEmail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-LoginEmailAccountRequest\">LoginEmailAccountRequest</a>). | [optional] 

### Return type

[**LoginResponse**](LoginResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAuthLoginId**
> LoginResponse deviceBindingAuthLoginId(applicationId, deviceBoundRequest)

Login account with ID.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAuthApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-LoginIdAccountRequest\">LoginIdAccountRequest</a>).

try {
    final response = api.deviceBindingAuthLoginId(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAuthApi->deviceBindingAuthLoginId: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-LoginIdAccountRequest\">LoginIdAccountRequest</a>). | [optional] 

### Return type

[**LoginResponse**](LoginResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAuthLoginUsername**
> LoginResponse deviceBindingAuthLoginUsername(applicationId, deviceBoundRequest)

Login username account.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAuthApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-LoginEmailAccountRequest\">LoginEmailAccountRequest</a>).

try {
    final response = api.deviceBindingAuthLoginUsername(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAuthApi->deviceBindingAuthLoginUsername: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-LoginEmailAccountRequest\">LoginEmailAccountRequest</a>). | [optional] 

### Return type

[**LoginResponse**](LoginResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAuthLogout**
> SuccessResponse deviceBindingAuthLogout(applicationId, deviceBoundRequest)

Logout.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAuthApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-LogoutUserRequest\">LogoutUserRequest</a>).

try {
    final response = api.deviceBindingAuthLogout(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAuthApi->deviceBindingAuthLogout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-LogoutUserRequest\">LogoutUserRequest</a>). | [optional] 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAuthRefreshToken**
> RefreshTokenResponse deviceBindingAuthRefreshToken(applicationId, deviceBoundRequest)

Refresh token.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAuthApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-RefreshTokenRequest\">RefreshTokenRequest</a>).

try {
    final response = api.deviceBindingAuthRefreshToken(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAuthApi->deviceBindingAuthRefreshToken: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-RefreshTokenRequest\">RefreshTokenRequest</a>). | [optional] 

### Return type

[**RefreshTokenResponse**](RefreshTokenResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


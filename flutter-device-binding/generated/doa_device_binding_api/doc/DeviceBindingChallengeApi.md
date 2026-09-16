# doa_device_binding_api.api.DeviceBindingChallengeApi

## Load the API package
```dart
import 'package:doa_device_binding_api/api.dart';
```

All URIs are relative to *https://pie.azuma-health.tech/api/organization*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deviceBindingChallengeGenerateBindingAdditionalDevice**](DeviceBindingChallengeApi.md#devicebindingchallengegeneratebindingadditionaldevice) | **GET** /deviceBinding/challenge/v1/mobile/{applicationId}/additionalDevice | Generate a challenge for device binding additional device.
[**deviceBindingChallengeGenerateBindingRefresh**](DeviceBindingChallengeApi.md#devicebindingchallengegeneratebindingrefresh) | **GET** /deviceBinding/challenge/v1/mobile/{applicationId}/bindingRefresh | Generate a challenge for device binding refresh.
[**deviceBindingChallengeGenerateLinking**](DeviceBindingChallengeApi.md#devicebindingchallengegeneratelinking) | **GET** /deviceBinding/challenge/v1/mobile/{applicationId}/linking | Generate a challenge for linking.
[**deviceBindingChallengeGenerateLogin**](DeviceBindingChallengeApi.md#devicebindingchallengegeneratelogin) | **GET** /deviceBinding/challenge/v1/mobile/{applicationId}/login | Generate a challenge for device binding login.
[**deviceBindingChallengeGenerateRefresh**](DeviceBindingChallengeApi.md#devicebindingchallengegeneraterefresh) | **GET** /deviceBinding/challenge/v1/mobile/{applicationId}/refresh | Generate a challenge for device binding refresh.
[**deviceBindingChallengeGenerateRegistration**](DeviceBindingChallengeApi.md#devicebindingchallengegenerateregistration) | **GET** /deviceBinding/challenge/v1/mobile/{applicationId}/registration | Generate a challenge for device binding registration.


# **deviceBindingChallengeGenerateBindingAdditionalDevice**
> ChallengeResponse deviceBindingChallengeGenerateBindingAdditionalDevice(applicationId)

Generate a challenge for device binding additional device.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingChallengeApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.

try {
    final response = api.deviceBindingChallengeGenerateBindingAdditionalDevice(applicationId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingChallengeApi->deviceBindingChallengeGenerateBindingAdditionalDevice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 

### Return type

[**ChallengeResponse**](ChallengeResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingChallengeGenerateBindingRefresh**
> ChallengeResponse deviceBindingChallengeGenerateBindingRefresh(applicationId)

Generate a challenge for device binding refresh.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingChallengeApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.

try {
    final response = api.deviceBindingChallengeGenerateBindingRefresh(applicationId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingChallengeApi->deviceBindingChallengeGenerateBindingRefresh: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 

### Return type

[**ChallengeResponse**](ChallengeResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingChallengeGenerateLinking**
> ChallengeResponse deviceBindingChallengeGenerateLinking(applicationId)

Generate a challenge for linking.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingChallengeApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.

try {
    final response = api.deviceBindingChallengeGenerateLinking(applicationId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingChallengeApi->deviceBindingChallengeGenerateLinking: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 

### Return type

[**ChallengeResponse**](ChallengeResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingChallengeGenerateLogin**
> ChallengeResponse deviceBindingChallengeGenerateLogin(applicationId)

Generate a challenge for device binding login.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingChallengeApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.

try {
    final response = api.deviceBindingChallengeGenerateLogin(applicationId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingChallengeApi->deviceBindingChallengeGenerateLogin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 

### Return type

[**ChallengeResponse**](ChallengeResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingChallengeGenerateRefresh**
> ChallengeResponse deviceBindingChallengeGenerateRefresh(applicationId)

Generate a challenge for device binding refresh.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingChallengeApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.

try {
    final response = api.deviceBindingChallengeGenerateRefresh(applicationId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingChallengeApi->deviceBindingChallengeGenerateRefresh: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 

### Return type

[**ChallengeResponse**](ChallengeResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingChallengeGenerateRegistration**
> ChallengeResponse deviceBindingChallengeGenerateRegistration(applicationId)

Generate a challenge for device binding registration.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingChallengeApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.

try {
    final response = api.deviceBindingChallengeGenerateRegistration(applicationId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingChallengeApi->deviceBindingChallengeGenerateRegistration: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 

### Return type

[**ChallengeResponse**](ChallengeResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


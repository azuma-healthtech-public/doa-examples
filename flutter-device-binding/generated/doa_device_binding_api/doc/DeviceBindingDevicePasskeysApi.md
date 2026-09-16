# doa_device_binding_api.api.DeviceBindingDevicePasskeysApi

## Load the API package
```dart
import 'package:doa_device_binding_api/api.dart';
```

All URIs are relative to *https://pie.azuma-health.tech/api/organization*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deviceBindingDeviceRegisterViaPasskeysGenOptions**](DeviceBindingDevicePasskeysApi.md#devicebindingdeviceregisterviapasskeysgenoptions) | **POST** /deviceBinding/device/v1/mobile/{applicationId}/register/passkeys/generate-options | Register additional device via passkeys. Generate options API.
[**deviceBindingDeviceRegisterViaPasskeysVerify**](DeviceBindingDevicePasskeysApi.md#devicebindingdeviceregisterviapasskeysverify) | **POST** /deviceBinding/device/v1/mobile/{applicationId}/register/passkeys/verify | Register additional device via passkeys. Verify API.


# **deviceBindingDeviceRegisterViaPasskeysGenOptions**
> DeviceBindingRegisterDevicePasskeysOptionsResponse deviceBindingDeviceRegisterViaPasskeysGenOptions(applicationId, deviceBindingRegisterDevicePasskeysOptionsRequest)

Register additional device via passkeys. Generate options API.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingDevicePasskeysApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBindingRegisterDevicePasskeysOptionsRequest deviceBindingRegisterDevicePasskeysOptionsRequest = ; // DeviceBindingRegisterDevicePasskeysOptionsRequest | Request payload.

try {
    final response = api.deviceBindingDeviceRegisterViaPasskeysGenOptions(applicationId, deviceBindingRegisterDevicePasskeysOptionsRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingDevicePasskeysApi->deviceBindingDeviceRegisterViaPasskeysGenOptions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBindingRegisterDevicePasskeysOptionsRequest** | [**DeviceBindingRegisterDevicePasskeysOptionsRequest**](DeviceBindingRegisterDevicePasskeysOptionsRequest.md)| Request payload. | [optional] 

### Return type

[**DeviceBindingRegisterDevicePasskeysOptionsResponse**](DeviceBindingRegisterDevicePasskeysOptionsResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingDeviceRegisterViaPasskeysVerify**
> DeviceBindingRegisterDevicePasskeysVerifyResponse deviceBindingDeviceRegisterViaPasskeysVerify(applicationId, deviceBindingRegisterDevicePasskeysVerifyRequest)

Register additional device via passkeys. Verify API.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingDevicePasskeysApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBindingRegisterDevicePasskeysVerifyRequest deviceBindingRegisterDevicePasskeysVerifyRequest = ; // DeviceBindingRegisterDevicePasskeysVerifyRequest | Request payload.

try {
    final response = api.deviceBindingDeviceRegisterViaPasskeysVerify(applicationId, deviceBindingRegisterDevicePasskeysVerifyRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingDevicePasskeysApi->deviceBindingDeviceRegisterViaPasskeysVerify: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBindingRegisterDevicePasskeysVerifyRequest** | [**DeviceBindingRegisterDevicePasskeysVerifyRequest**](DeviceBindingRegisterDevicePasskeysVerifyRequest.md)| Request payload. | [optional] 

### Return type

[**DeviceBindingRegisterDevicePasskeysVerifyResponse**](DeviceBindingRegisterDevicePasskeysVerifyResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


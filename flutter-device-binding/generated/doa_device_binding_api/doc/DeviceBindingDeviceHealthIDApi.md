# doa_device_binding_api.api.DeviceBindingDeviceHealthIDApi

## Load the API package
```dart
import 'package:doa_device_binding_api/api.dart';
```

All URIs are relative to *https://pie.azuma-health.tech/api/organization*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deviceBindingDeviceRegisterAdditionalViaHealthId**](DeviceBindingDeviceHealthIDApi.md#devicebindingdeviceregisteradditionalviahealthid) | **POST** /deviceBinding/device/v1/mobile/{applicationId}/register/healthId | Register additional device via healthId.


# **deviceBindingDeviceRegisterAdditionalViaHealthId**
> LoginResponse deviceBindingDeviceRegisterAdditionalViaHealthId(applicationId, deviceBindingRegisterAdditionalDeviceHealthIdRequest)

Register additional device via healthId.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingDeviceHealthIDApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBindingRegisterAdditionalDeviceHealthIdRequest deviceBindingRegisterAdditionalDeviceHealthIdRequest = ; // DeviceBindingRegisterAdditionalDeviceHealthIdRequest | Request payload.

try {
    final response = api.deviceBindingDeviceRegisterAdditionalViaHealthId(applicationId, deviceBindingRegisterAdditionalDeviceHealthIdRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingDeviceHealthIDApi->deviceBindingDeviceRegisterAdditionalViaHealthId: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBindingRegisterAdditionalDeviceHealthIdRequest** | [**DeviceBindingRegisterAdditionalDeviceHealthIdRequest**](DeviceBindingRegisterAdditionalDeviceHealthIdRequest.md)| Request payload. | [optional] 

### Return type

[**LoginResponse**](LoginResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


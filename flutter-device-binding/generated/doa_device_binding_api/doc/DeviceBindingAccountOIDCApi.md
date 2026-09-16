# doa_device_binding_api.api.DeviceBindingAccountOIDCApi

## Load the API package
```dart
import 'package:doa_device_binding_api/api.dart';
```

All URIs are relative to *https://pie.azuma-health.tech/api/organization*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deviceBindingAccountRegisterAccountApple**](DeviceBindingAccountOIDCApi.md#devicebindingaccountregisteraccountapple) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/register/apple | Register a new apple account via token exchange.
[**deviceBindingAccountRegisterAccountGoogle**](DeviceBindingAccountOIDCApi.md#devicebindingaccountregisteraccountgoogle) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/register/google | Register a new google account via token exchange.


# **deviceBindingAccountRegisterAccountApple**
> DeviceBindingRegisterOidcAccountResponse deviceBindingAccountRegisterAccountApple(applicationId, deviceBindingRegisterOidcAccountRequest)

Register a new apple account via token exchange.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountOIDCApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBindingRegisterOidcAccountRequest deviceBindingRegisterOidcAccountRequest = ; // DeviceBindingRegisterOidcAccountRequest | Register account request data.

try {
    final response = api.deviceBindingAccountRegisterAccountApple(applicationId, deviceBindingRegisterOidcAccountRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountOIDCApi->deviceBindingAccountRegisterAccountApple: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBindingRegisterOidcAccountRequest** | [**DeviceBindingRegisterOidcAccountRequest**](DeviceBindingRegisterOidcAccountRequest.md)| Register account request data. | [optional] 

### Return type

[**DeviceBindingRegisterOidcAccountResponse**](DeviceBindingRegisterOidcAccountResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAccountRegisterAccountGoogle**
> DeviceBindingRegisterOidcAccountResponse deviceBindingAccountRegisterAccountGoogle(applicationId, deviceBindingRegisterOidcAccountRequest)

Register a new google account via token exchange.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountOIDCApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBindingRegisterOidcAccountRequest deviceBindingRegisterOidcAccountRequest = ; // DeviceBindingRegisterOidcAccountRequest | Register account request data.

try {
    final response = api.deviceBindingAccountRegisterAccountGoogle(applicationId, deviceBindingRegisterOidcAccountRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountOIDCApi->deviceBindingAccountRegisterAccountGoogle: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBindingRegisterOidcAccountRequest** | [**DeviceBindingRegisterOidcAccountRequest**](DeviceBindingRegisterOidcAccountRequest.md)| Register account request data. | [optional] 

### Return type

[**DeviceBindingRegisterOidcAccountResponse**](DeviceBindingRegisterOidcAccountResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


# doa_device_binding_api.api.DeviceBindingAccountApi

## Load the API package
```dart
import 'package:doa_device_binding_api/api.dart';
```

All URIs are relative to *https://pie.azuma-health.tech/api/organization*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deviceBindingAccountChangePassword**](DeviceBindingAccountApi.md#devicebindingaccountchangepassword) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/changePassword | Change password.
[**deviceBindingAccountChangePasswordViaRecovery**](DeviceBindingAccountApi.md#devicebindingaccountchangepasswordviarecovery) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/recover/changePassword | Change password via recovery.
[**deviceBindingAccountConfirmRecoveryAccountEmail**](DeviceBindingAccountApi.md#devicebindingaccountconfirmrecoveryaccountemail) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/recover/email/confirm | Confirms password recovery for an email account.
[**deviceBindingAccountConfirmVerificationAccountEmail**](DeviceBindingAccountApi.md#devicebindingaccountconfirmverificationaccountemail) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/verify/email/confirm | Confirms the verification of an email of an existing account.
[**deviceBindingAccountGetUserInfo**](DeviceBindingAccountApi.md#devicebindingaccountgetuserinfo) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/userInfo | Get user data
[**deviceBindingAccountInitiateRecoveryAccountEmail**](DeviceBindingAccountApi.md#devicebindingaccountinitiaterecoveryaccountemail) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/recover/email/initiate | Initiates password recovery for an email account.
[**deviceBindingAccountInitiateVerificationAccountEmail**](DeviceBindingAccountApi.md#devicebindingaccountinitiateverificationaccountemail) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/verify/email/initiate | Initiates email verification for an existing account.
[**deviceBindingAccountRegisterAccountEmail**](DeviceBindingAccountApi.md#devicebindingaccountregisteraccountemail) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/register/email | Register a new email account.
[**deviceBindingAccountRegisterAccountUsername**](DeviceBindingAccountApi.md#devicebindingaccountregisteraccountusername) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/register/username | Register a new username account.


# **deviceBindingAccountChangePassword**
> SuccessResponse deviceBindingAccountChangePassword(applicationId, deviceBoundRequest)

Change password.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-ChangePasswordLoggedInUserRequest\">ChangePasswordLoggedInUserRequest</a>).  Important:  <ul><li>In case the login was done > 5 Minutes ago, a new login is required.</li><li>In case the last login was done via a refresh, a new login is required.</li></ul>

try {
    final response = api.deviceBindingAccountChangePassword(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountApi->deviceBindingAccountChangePassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-ChangePasswordLoggedInUserRequest\">ChangePasswordLoggedInUserRequest</a>).  Important:  <ul><li>In case the login was done > 5 Minutes ago, a new login is required.</li><li>In case the last login was done via a refresh, a new login is required.</li></ul> | [optional] 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAccountChangePasswordViaRecovery**
> SuccessResponse deviceBindingAccountChangePasswordViaRecovery(applicationId, deviceBoundRequest)

Change password via recovery.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-ChangePasswordRequest\">ChangePasswordRequest</a>).

try {
    final response = api.deviceBindingAccountChangePasswordViaRecovery(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountApi->deviceBindingAccountChangePasswordViaRecovery: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-ChangePasswordRequest\">ChangePasswordRequest</a>). | [optional] 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAccountConfirmRecoveryAccountEmail**
> ConfirmEmailRecoveryResponse deviceBindingAccountConfirmRecoveryAccountEmail(applicationId, deviceBoundRequest)

Confirms password recovery for an email account.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-ConfirmRecoveryEmailRequest\">ConfirmRecoveryEmailRequest</a>).

try {
    final response = api.deviceBindingAccountConfirmRecoveryAccountEmail(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountApi->deviceBindingAccountConfirmRecoveryAccountEmail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-ConfirmRecoveryEmailRequest\">ConfirmRecoveryEmailRequest</a>). | [optional] 

### Return type

[**ConfirmEmailRecoveryResponse**](ConfirmEmailRecoveryResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAccountConfirmVerificationAccountEmail**
> SuccessResponse deviceBindingAccountConfirmVerificationAccountEmail(applicationId, deviceBoundRequest)

Confirms the verification of an email of an existing account.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-ConfirmAccountEmailRequest\">ConfirmAccountEmailRequest</a>).

try {
    final response = api.deviceBindingAccountConfirmVerificationAccountEmail(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountApi->deviceBindingAccountConfirmVerificationAccountEmail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-ConfirmAccountEmailRequest\">ConfirmAccountEmailRequest</a>). | [optional] 

### Return type

[**SuccessResponse**](SuccessResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAccountGetUserInfo**
> UserInfoResponse deviceBindingAccountGetUserInfo(applicationId, deviceBoundRequest)

Get user data

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-UserInfoRequest\">UserInfoRequest</a>).

try {
    final response = api.deviceBindingAccountGetUserInfo(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountApi->deviceBindingAccountGetUserInfo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-UserInfoRequest\">UserInfoRequest</a>). | [optional] 

### Return type

[**UserInfoResponse**](UserInfoResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAccountInitiateRecoveryAccountEmail**
> InitiateEmailRecoveryResponse deviceBindingAccountInitiateRecoveryAccountEmail(applicationId, deviceBoundRequest)

Initiates password recovery for an email account.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-InitiateEmailRecoveryRequest\">InitiateEmailRecoveryRequest</a>).

try {
    final response = api.deviceBindingAccountInitiateRecoveryAccountEmail(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountApi->deviceBindingAccountInitiateRecoveryAccountEmail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-InitiateEmailRecoveryRequest\">InitiateEmailRecoveryRequest</a>). | [optional] 

### Return type

[**InitiateEmailRecoveryResponse**](InitiateEmailRecoveryResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAccountInitiateVerificationAccountEmail**
> InitiateEmailVerificationResponse deviceBindingAccountInitiateVerificationAccountEmail(applicationId, deviceBoundRequest)

Initiates email verification for an existing account.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-InitiateEmailVerificationRequest\">InitiateEmailVerificationRequest</a>).

try {
    final response = api.deviceBindingAccountInitiateVerificationAccountEmail(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountApi->deviceBindingAccountInitiateVerificationAccountEmail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-InitiateEmailVerificationRequest\">InitiateEmailVerificationRequest</a>). | [optional] 

### Return type

[**InitiateEmailVerificationResponse**](InitiateEmailVerificationResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAccountRegisterAccountEmail**
> DeviceBindingRegisterEmailAccountResponse deviceBindingAccountRegisterAccountEmail(applicationId, deviceBindingRegisterEmailAccountRequest)

Register a new email account.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBindingRegisterEmailAccountRequest deviceBindingRegisterEmailAccountRequest = ; // DeviceBindingRegisterEmailAccountRequest | Register account request data.

try {
    final response = api.deviceBindingAccountRegisterAccountEmail(applicationId, deviceBindingRegisterEmailAccountRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountApi->deviceBindingAccountRegisterAccountEmail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBindingRegisterEmailAccountRequest** | [**DeviceBindingRegisterEmailAccountRequest**](DeviceBindingRegisterEmailAccountRequest.md)| Register account request data. | [optional] 

### Return type

[**DeviceBindingRegisterEmailAccountResponse**](DeviceBindingRegisterEmailAccountResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceBindingAccountRegisterAccountUsername**
> DeviceBindingRegisterUsernameAccountResponse deviceBindingAccountRegisterAccountUsername(applicationId, deviceBindingRegisterUsernameAccountRequest)

Register a new username account.

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAccountApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBindingRegisterUsernameAccountRequest deviceBindingRegisterUsernameAccountRequest = ; // DeviceBindingRegisterUsernameAccountRequest | Register account request data.

try {
    final response = api.deviceBindingAccountRegisterAccountUsername(applicationId, deviceBindingRegisterUsernameAccountRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAccountApi->deviceBindingAccountRegisterAccountUsername: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBindingRegisterUsernameAccountRequest** | [**DeviceBindingRegisterUsernameAccountRequest**](DeviceBindingRegisterUsernameAccountRequest.md)| Register account request data. | [optional] 

### Return type

[**DeviceBindingRegisterUsernameAccountResponse**](DeviceBindingRegisterUsernameAccountResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


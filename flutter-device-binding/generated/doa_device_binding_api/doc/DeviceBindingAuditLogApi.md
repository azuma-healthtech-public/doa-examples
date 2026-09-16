# doa_device_binding_api.api.DeviceBindingAuditLogApi

## Load the API package
```dart
import 'package:doa_device_binding_api/api.dart';
```

All URIs are relative to *https://pie.azuma-health.tech/api/organization*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deviceBindingAuditLogsGetAuthEvents**](DeviceBindingAuditLogApi.md#devicebindingauditlogsgetauthevents) | **POST** /deviceBinding/account/v1/mobile/{applicationId}/authEvents | Get audit log for all auth events (paginated).


# **deviceBindingAuditLogsGetAuthEvents**
> DeviceBindingAuditLogAuthEventsPageResponse deviceBindingAuditLogsGetAuthEvents(applicationId, deviceBoundRequest)

Get audit log for all auth events (paginated).

### Example
```dart
import 'package:doa_device_binding_api/api.dart';

final api = DoaDeviceBindingApi().getDeviceBindingAuditLogApi();
final String applicationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | ID of the application.
final DeviceBoundRequest deviceBoundRequest = ; // DeviceBoundRequest | Request payload. (Payload: <a href=\"#model-DeviceBindingAuditLogAuthEventsRequest\">DeviceBindingAuditLogAuthEventsRequest</a>).

try {
    final response = api.deviceBindingAuditLogsGetAuthEvents(applicationId, deviceBoundRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DeviceBindingAuditLogApi->deviceBindingAuditLogsGetAuthEvents: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **applicationId** | **String**| ID of the application. | 
 **deviceBoundRequest** | [**DeviceBoundRequest**](DeviceBoundRequest.md)| Request payload. (Payload: <a href=\"#model-DeviceBindingAuditLogAuthEventsRequest\">DeviceBindingAuditLogAuthEventsRequest</a>). | [optional] 

### Return type

[**DeviceBindingAuditLogAuthEventsPageResponse**](DeviceBindingAuditLogAuthEventsPageResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)


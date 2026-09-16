# doa_device_binding_api.model.DeviceBindingAuditLogAuthEventsRequest

## Load the model package
```dart
import 'package:doa_device_binding_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | [optional] 
**accessToken** | **String** |  | [optional] 
**page** | **int** |  | [optional] 
**pageSize** | **int** | Max value: 20 | [optional] 
**includedLogTypes** | [**List&lt;AuditLogType&gt;**](AuditLogType.md) | Included log types from DeviceBindingAuth, DeviceBindingAccount, DeviceBindingDevice and DeviceBindingSession categories. Can be left empty or null to include all events from those categories. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)



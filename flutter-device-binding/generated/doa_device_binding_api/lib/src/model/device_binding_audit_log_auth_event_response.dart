//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/user_device_data.dart';
import 'package:doa_device_binding_api/src/model/audit_log_type.dart';
import 'package:doa_device_binding_api/src/model/audit_log_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_audit_log_auth_event_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingAuditLogAuthEventResponse {
  /// Returns a new [DeviceBindingAuditLogAuthEventResponse] instance.
  DeviceBindingAuditLogAuthEventResponse({

     this.createdAt,

     this.status,

     this.type,

     this.executingUserDeviceData,

     this.errorCode,

     this.errorData,
  });

  @JsonKey(
    
    name: r'createdAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? createdAt;



  @JsonKey(
    
    name: r'status',
    required: false,
    includeIfNull: false,
  )


  final AuditLogStatus? status;



  @JsonKey(
    
    name: r'type',
    required: false,
    includeIfNull: false,
  )


  final AuditLogType? type;



  @JsonKey(
    
    name: r'executingUserDeviceData',
    required: false,
    includeIfNull: false,
  )


  final UserDeviceData? executingUserDeviceData;



  @JsonKey(
    
    name: r'errorCode',
    required: false,
    includeIfNull: false,
  )


  final String? errorCode;



  @JsonKey(
    
    name: r'errorData',
    required: false,
    includeIfNull: false,
  )


  final String? errorData;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingAuditLogAuthEventResponse &&
      other.createdAt == createdAt &&
      other.status == status &&
      other.type == type &&
      other.executingUserDeviceData == executingUserDeviceData &&
      other.errorCode == errorCode &&
      other.errorData == errorData;

    @override
    int get hashCode =>
        createdAt.hashCode +
        status.hashCode +
        type.hashCode +
        executingUserDeviceData.hashCode +
        (errorCode == null ? 0 : errorCode.hashCode) +
        (errorData == null ? 0 : errorData.hashCode);

  factory DeviceBindingAuditLogAuthEventResponse.fromJson(Map<String, dynamic> json) => _$DeviceBindingAuditLogAuthEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingAuditLogAuthEventResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


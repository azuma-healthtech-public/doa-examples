//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/audit_log_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_audit_log_auth_events_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingAuditLogAuthEventsRequest {
  /// Returns a new [DeviceBindingAuditLogAuthEventsRequest] instance.
  DeviceBindingAuditLogAuthEventsRequest({

     this.id,

     this.accessToken,

     this.page,

     this.pageSize,

     this.includedLogTypes,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



  @JsonKey(
    
    name: r'accessToken',
    required: false,
    includeIfNull: false,
  )


  final String? accessToken;



  @JsonKey(
    
    name: r'page',
    required: false,
    includeIfNull: false,
  )


  final int? page;



      /// Max value: 20
  @JsonKey(
    
    name: r'pageSize',
    required: false,
    includeIfNull: false,
  )


  final int? pageSize;



      /// Included log types from DeviceBindingAuth, DeviceBindingAccount, DeviceBindingDevice and DeviceBindingSession categories. Can be left empty or null to include all events from those categories.
  @JsonKey(
    
    name: r'includedLogTypes',
    required: false,
    includeIfNull: false,
  )


  final List<AuditLogType>? includedLogTypes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingAuditLogAuthEventsRequest &&
      other.id == id &&
      other.accessToken == accessToken &&
      other.page == page &&
      other.pageSize == pageSize &&
      other.includedLogTypes == includedLogTypes;

    @override
    int get hashCode =>
        id.hashCode +
        (accessToken == null ? 0 : accessToken.hashCode) +
        page.hashCode +
        pageSize.hashCode +
        (includedLogTypes == null ? 0 : includedLogTypes.hashCode);

  factory DeviceBindingAuditLogAuthEventsRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingAuditLogAuthEventsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingAuditLogAuthEventsRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


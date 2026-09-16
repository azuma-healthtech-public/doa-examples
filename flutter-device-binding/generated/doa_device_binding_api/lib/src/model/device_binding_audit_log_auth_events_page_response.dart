//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/device_binding_audit_log_auth_event_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_audit_log_auth_events_page_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingAuditLogAuthEventsPageResponse {
  /// Returns a new [DeviceBindingAuditLogAuthEventsPageResponse] instance.
  DeviceBindingAuditLogAuthEventsPageResponse({

     this.hasMore,

     this.items,
  });

  @JsonKey(
    
    name: r'hasMore',
    required: false,
    includeIfNull: false,
  )


  final bool? hasMore;



  @JsonKey(
    
    name: r'items',
    required: false,
    includeIfNull: false,
  )


  final List<DeviceBindingAuditLogAuthEventResponse>? items;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingAuditLogAuthEventsPageResponse &&
      other.hasMore == hasMore &&
      other.items == items;

    @override
    int get hashCode =>
        hasMore.hashCode +
        (items == null ? 0 : items.hashCode);

  factory DeviceBindingAuditLogAuthEventsPageResponse.fromJson(Map<String, dynamic> json) => _$DeviceBindingAuditLogAuthEventsPageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingAuditLogAuthEventsPageResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


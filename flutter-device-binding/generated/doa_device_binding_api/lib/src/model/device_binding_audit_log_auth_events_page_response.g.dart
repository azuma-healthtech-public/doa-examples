// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_binding_audit_log_auth_events_page_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceBindingAuditLogAuthEventsPageResponse
_$DeviceBindingAuditLogAuthEventsPageResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DeviceBindingAuditLogAuthEventsPageResponse', json, (
  $checkedConvert,
) {
  final val = DeviceBindingAuditLogAuthEventsPageResponse(
    hasMore: $checkedConvert('hasMore', (v) => v as bool?),
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>?)
          ?.map(
            (e) => DeviceBindingAuditLogAuthEventResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$DeviceBindingAuditLogAuthEventsPageResponseToJson(
  DeviceBindingAuditLogAuthEventsPageResponse instance,
) => <String, dynamic>{
  'hasMore': ?instance.hasMore,
  'items': ?instance.items?.map((e) => e.toJson()).toList(),
};

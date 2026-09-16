//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';


enum AuditLogStatus {
      @JsonValue(r'Unknown')
      unknown(r'Unknown'),
      @JsonValue(r'Error')
      error(r'Error'),
      @JsonValue(r'Success')
      success(r'Success');

  const AuditLogStatus(this.value);

  final String value;

  @override
  String toString() => value;
}

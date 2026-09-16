//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';


enum UserRegistrationStatus {
      @JsonValue(r'Pending')
      pending(r'Pending'),
      @JsonValue(r'Invited')
      invited(r'Invited'),
      @JsonValue(r'Finished')
      finished(r'Finished');

  const UserRegistrationStatus(this.value);

  final String value;

  @override
  String toString() => value;
}

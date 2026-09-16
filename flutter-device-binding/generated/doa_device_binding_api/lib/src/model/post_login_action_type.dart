//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';


enum PostLoginActionType {
      @JsonValue(r'PasswordChangeRequired')
      passwordChangeRequired(r'PasswordChangeRequired'),
      @JsonValue(r'DeviceBindingExpired')
      deviceBindingExpired(r'DeviceBindingExpired'),
      @JsonValue(r'DeviceBindingNearingExpiration')
      deviceBindingNearingExpiration(r'DeviceBindingNearingExpiration'),
      @JsonValue(r'DeviceAttestationKeyMissing')
      deviceAttestationKeyMissing(r'DeviceAttestationKeyMissing');

  const PostLoginActionType(this.value);

  final String value;

  @override
  String toString() => value;
}

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_passkeys_login_options_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingPasskeysLoginOptionsRequest {
  /// Returns a new [DeviceBindingPasskeysLoginOptionsRequest] instance.
  DeviceBindingPasskeysLoginOptionsRequest({

    required  this.identifier,
  });

  @JsonKey(
    
    name: r'identifier',
    required: true,
    includeIfNull: false,
  )


  final String identifier;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingPasskeysLoginOptionsRequest &&
      other.identifier == identifier;

    @override
    int get hashCode =>
        identifier.hashCode;

  factory DeviceBindingPasskeysLoginOptionsRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingPasskeysLoginOptionsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingPasskeysLoginOptionsRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


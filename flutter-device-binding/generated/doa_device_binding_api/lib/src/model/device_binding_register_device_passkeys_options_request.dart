//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_register_device_passkeys_options_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingRegisterDevicePasskeysOptionsRequest {
  /// Returns a new [DeviceBindingRegisterDevicePasskeysOptionsRequest] instance.
  DeviceBindingRegisterDevicePasskeysOptionsRequest({

     this.identifier,
  });

  @JsonKey(
    
    name: r'identifier',
    required: false,
    includeIfNull: false,
  )


  final String? identifier;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingRegisterDevicePasskeysOptionsRequest &&
      other.identifier == identifier;

    @override
    int get hashCode =>
        (identifier == null ? 0 : identifier.hashCode);

  factory DeviceBindingRegisterDevicePasskeysOptionsRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingRegisterDevicePasskeysOptionsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingRegisterDevicePasskeysOptionsRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


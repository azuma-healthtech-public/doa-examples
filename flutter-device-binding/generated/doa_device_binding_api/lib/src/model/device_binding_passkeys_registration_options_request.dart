//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_passkeys_registration_options_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingPasskeysRegistrationOptionsRequest {
  /// Returns a new [DeviceBindingPasskeysRegistrationOptionsRequest] instance.
  DeviceBindingPasskeysRegistrationOptionsRequest({

    required  this.identifier,
  });

  @JsonKey(
    
    name: r'identifier',
    required: true,
    includeIfNull: true,
  )


  final String? identifier;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingPasskeysRegistrationOptionsRequest &&
      other.identifier == identifier;

    @override
    int get hashCode =>
        (identifier == null ? 0 : identifier.hashCode);

  factory DeviceBindingPasskeysRegistrationOptionsRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingPasskeysRegistrationOptionsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingPasskeysRegistrationOptionsRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


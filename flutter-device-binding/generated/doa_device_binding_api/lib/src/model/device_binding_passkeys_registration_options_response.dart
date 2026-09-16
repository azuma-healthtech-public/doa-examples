//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_passkeys_registration_options_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingPasskeysRegistrationOptionsResponse {
  /// Returns a new [DeviceBindingPasskeysRegistrationOptionsResponse] instance.
  DeviceBindingPasskeysRegistrationOptionsResponse({

     this.options,
  });

  @JsonKey(
    
    name: r'options',
    required: false,
    includeIfNull: false,
  )


  final String? options;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingPasskeysRegistrationOptionsResponse &&
      other.options == options;

    @override
    int get hashCode =>
        (options == null ? 0 : options.hashCode);

  factory DeviceBindingPasskeysRegistrationOptionsResponse.fromJson(Map<String, dynamic> json) => _$DeviceBindingPasskeysRegistrationOptionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingPasskeysRegistrationOptionsResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_register_device_passkeys_options_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingRegisterDevicePasskeysOptionsResponse {
  /// Returns a new [DeviceBindingRegisterDevicePasskeysOptionsResponse] instance.
  DeviceBindingRegisterDevicePasskeysOptionsResponse({

     this.accountId,

     this.options,
  });

  @JsonKey(
    
    name: r'accountId',
    required: false,
    includeIfNull: false,
  )


  final String? accountId;



  @JsonKey(
    
    name: r'options',
    required: false,
    includeIfNull: false,
  )


  final String? options;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingRegisterDevicePasskeysOptionsResponse &&
      other.accountId == accountId &&
      other.options == options;

    @override
    int get hashCode =>
        (accountId == null ? 0 : accountId.hashCode) +
        (options == null ? 0 : options.hashCode);

  factory DeviceBindingRegisterDevicePasskeysOptionsResponse.fromJson(Map<String, dynamic> json) => _$DeviceBindingRegisterDevicePasskeysOptionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingRegisterDevicePasskeysOptionsResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


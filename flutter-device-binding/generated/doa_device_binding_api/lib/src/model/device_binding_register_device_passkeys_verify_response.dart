//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/login_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_register_device_passkeys_verify_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingRegisterDevicePasskeysVerifyResponse {
  /// Returns a new [DeviceBindingRegisterDevicePasskeysVerifyResponse] instance.
  DeviceBindingRegisterDevicePasskeysVerifyResponse({

     this.id,

     this.token,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



  @JsonKey(
    
    name: r'token',
    required: false,
    includeIfNull: false,
  )


  final LoginResponse? token;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingRegisterDevicePasskeysVerifyResponse &&
      other.id == id &&
      other.token == token;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        token.hashCode;

  factory DeviceBindingRegisterDevicePasskeysVerifyResponse.fromJson(Map<String, dynamic> json) => _$DeviceBindingRegisterDevicePasskeysVerifyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingRegisterDevicePasskeysVerifyResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


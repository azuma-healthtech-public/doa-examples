//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_register_username_account_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingRegisterUsernameAccountResponse {
  /// Returns a new [DeviceBindingRegisterUsernameAccountResponse] instance.
  DeviceBindingRegisterUsernameAccountResponse({

    required  this.id,

     this.deviceAttestationKey,
  });

      /// Id of the created account.
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: true,
  )


  final String? id;



      /// Device AttestationKey of the created account.
  @JsonKey(
    
    name: r'deviceAttestationKey',
    required: false,
    includeIfNull: false,
  )


  final String? deviceAttestationKey;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingRegisterUsernameAccountResponse &&
      other.id == id &&
      other.deviceAttestationKey == deviceAttestationKey;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        (deviceAttestationKey == null ? 0 : deviceAttestationKey.hashCode);

  factory DeviceBindingRegisterUsernameAccountResponse.fromJson(Map<String, dynamic> json) => _$DeviceBindingRegisterUsernameAccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingRegisterUsernameAccountResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


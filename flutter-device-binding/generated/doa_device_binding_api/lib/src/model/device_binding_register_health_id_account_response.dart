//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_register_health_id_account_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingRegisterHealthIdAccountResponse {
  /// Returns a new [DeviceBindingRegisterHealthIdAccountResponse] instance.
  DeviceBindingRegisterHealthIdAccountResponse({

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
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingRegisterHealthIdAccountResponse &&
      other.id == id &&
      other.deviceAttestationKey == deviceAttestationKey;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        (deviceAttestationKey == null ? 0 : deviceAttestationKey.hashCode);

  factory DeviceBindingRegisterHealthIdAccountResponse.fromJson(Map<String, dynamic> json) => _$DeviceBindingRegisterHealthIdAccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingRegisterHealthIdAccountResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


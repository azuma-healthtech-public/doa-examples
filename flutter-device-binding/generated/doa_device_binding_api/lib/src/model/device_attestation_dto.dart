//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/user_device_os.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_attestation_dto.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceAttestationDto {
  /// Returns a new [DeviceAttestationDto] instance.
  DeviceAttestationDto({

     this.deviceName,

     this.attestation,

     this.deviceOs,
  });

  @JsonKey(
    
    name: r'deviceName',
    required: false,
    includeIfNull: false,
  )


  final String? deviceName;



  @JsonKey(
    
    name: r'attestation',
    required: false,
    includeIfNull: false,
  )


  final String? attestation;



  @JsonKey(
    
    name: r'deviceOs',
    required: false,
    includeIfNull: false,
  )


  final UserDeviceOs? deviceOs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceAttestationDto &&
      other.deviceName == deviceName &&
      other.attestation == attestation &&
      other.deviceOs == deviceOs;

    @override
    int get hashCode =>
        (deviceName == null ? 0 : deviceName.hashCode) +
        (attestation == null ? 0 : attestation.hashCode) +
        deviceOs.hashCode;

  factory DeviceAttestationDto.fromJson(Map<String, dynamic> json) => _$DeviceAttestationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceAttestationDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


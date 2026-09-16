//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/device_attestation_dto.dart';
import 'package:doa_device_binding_api/src/model/user_device_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_refresh_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingRefreshRequest {
  /// Returns a new [DeviceBindingRefreshRequest] instance.
  DeviceBindingRefreshRequest({

     this.accessToken,

     this.deviceAttestationKey,

     this.requestChallenge,

     this.deviceData,

    required  this.deviceAttestation,

     this.iosHardwareKey,

     this.androidIntegrityToken,
  });

  @JsonKey(
    
    name: r'accessToken',
    required: false,
    includeIfNull: false,
  )


  final String? accessToken;



      /// Device attestation key (if required via options).
  @JsonKey(
    
    name: r'deviceAttestationKey',
    required: false,
    includeIfNull: false,
  )


  final String? deviceAttestationKey;



      /// Challenge as received via challenge API.
  @JsonKey(
    
    name: r'requestChallenge',
    required: false,
    includeIfNull: false,
  )


  final String? requestChallenge;



  @JsonKey(
    
    name: r'deviceData',
    required: false,
    includeIfNull: false,
  )


  final UserDeviceData? deviceData;



  @JsonKey(
    
    name: r'deviceAttestation',
    required: true,
    includeIfNull: false,
  )


  final DeviceAttestationDto deviceAttestation;



      /// IOS only: hardware key.
  @JsonKey(
    
    name: r'iosHardwareKey',
    required: false,
    includeIfNull: false,
  )


  final String? iosHardwareKey;



      /// Android only: integrity token.
  @JsonKey(
    
    name: r'androidIntegrityToken',
    required: false,
    includeIfNull: false,
  )


  final String? androidIntegrityToken;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingRefreshRequest &&
      other.accessToken == accessToken &&
      other.deviceAttestationKey == deviceAttestationKey &&
      other.requestChallenge == requestChallenge &&
      other.deviceData == deviceData &&
      other.deviceAttestation == deviceAttestation &&
      other.iosHardwareKey == iosHardwareKey &&
      other.androidIntegrityToken == androidIntegrityToken;

    @override
    int get hashCode =>
        (accessToken == null ? 0 : accessToken.hashCode) +
        (deviceAttestationKey == null ? 0 : deviceAttestationKey.hashCode) +
        (requestChallenge == null ? 0 : requestChallenge.hashCode) +
        deviceData.hashCode +
        deviceAttestation.hashCode +
        (iosHardwareKey == null ? 0 : iosHardwareKey.hashCode) +
        (androidIntegrityToken == null ? 0 : androidIntegrityToken.hashCode);

  factory DeviceBindingRefreshRequest.fromJson(Map<String, dynamic> json) => _$DeviceBindingRefreshRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingRefreshRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


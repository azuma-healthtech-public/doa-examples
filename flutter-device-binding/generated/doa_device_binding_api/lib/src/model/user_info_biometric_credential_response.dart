//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/user_device_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_info_biometric_credential_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserInfoBiometricCredentialResponse {
  /// Returns a new [UserInfoBiometricCredentialResponse] instance.
  UserInfoBiometricCredentialResponse({

     this.id,

     this.deviceData,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



  @JsonKey(
    
    name: r'deviceData',
    required: false,
    includeIfNull: false,
  )


  final UserDeviceData? deviceData;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserInfoBiometricCredentialResponse &&
      other.id == id &&
      other.deviceData == deviceData;

    @override
    int get hashCode =>
        id.hashCode +
        deviceData.hashCode;

  factory UserInfoBiometricCredentialResponse.fromJson(Map<String, dynamic> json) => _$UserInfoBiometricCredentialResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoBiometricCredentialResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


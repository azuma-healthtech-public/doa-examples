//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_register_email_account_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingRegisterEmailAccountResponse {
  /// Returns a new [DeviceBindingRegisterEmailAccountResponse] instance.
  DeviceBindingRegisterEmailAccountResponse({

    required  this.id,

     this.emailVerificationInitiated,

     this.verificationFlow,

     this.deviceAttestationKey,
  });

      /// Id of the created account.
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: true,
  )


  final String? id;



  @JsonKey(
    
    name: r'emailVerificationInitiated',
    required: false,
    includeIfNull: false,
  )


  final bool? emailVerificationInitiated;



      /// Email verification flow (if a verification was started);
  @JsonKey(
    
    name: r'verificationFlow',
    required: false,
    includeIfNull: false,
  )


  final String? verificationFlow;



      /// Device AttestationKey of the created account.
  @JsonKey(
    
    name: r'deviceAttestationKey',
    required: false,
    includeIfNull: false,
  )


  final String? deviceAttestationKey;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingRegisterEmailAccountResponse &&
      other.id == id &&
      other.emailVerificationInitiated == emailVerificationInitiated &&
      other.verificationFlow == verificationFlow &&
      other.deviceAttestationKey == deviceAttestationKey;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        emailVerificationInitiated.hashCode +
        (verificationFlow == null ? 0 : verificationFlow.hashCode) +
        (deviceAttestationKey == null ? 0 : deviceAttestationKey.hashCode);

  factory DeviceBindingRegisterEmailAccountResponse.fromJson(Map<String, dynamic> json) => _$DeviceBindingRegisterEmailAccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingRegisterEmailAccountResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


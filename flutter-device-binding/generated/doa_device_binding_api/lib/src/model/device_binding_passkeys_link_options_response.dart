//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'device_binding_passkeys_link_options_response.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceBindingPasskeysLinkOptionsResponse {
  /// Returns a new [DeviceBindingPasskeysLinkOptionsResponse] instance.
  DeviceBindingPasskeysLinkOptionsResponse({

     this.accountId,

     this.options,
  });

  @JsonKey(
    
    name: r'accountId',
    required: false,
    includeIfNull: false,
  )


  final String? accountId;



      /// Options for passkey registration.
  @JsonKey(
    
    name: r'options',
    required: false,
    includeIfNull: false,
  )


  final String? options;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceBindingPasskeysLinkOptionsResponse &&
      other.accountId == accountId &&
      other.options == options;

    @override
    int get hashCode =>
        (accountId == null ? 0 : accountId.hashCode) +
        (options == null ? 0 : options.hashCode);

  factory DeviceBindingPasskeysLinkOptionsResponse.fromJson(Map<String, dynamic> json) => _$DeviceBindingPasskeysLinkOptionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceBindingPasskeysLinkOptionsResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


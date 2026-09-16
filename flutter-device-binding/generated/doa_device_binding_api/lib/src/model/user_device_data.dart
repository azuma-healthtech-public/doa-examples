//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'user_device_data.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserDeviceData {
  /// Returns a new [UserDeviceData] instance.
  UserDeviceData({

     this.name,

     this.manufacturer,

     this.model,

     this.modelVersion,

     this.osVersion,

     this.os,

     this.extra,
  });

  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



  @JsonKey(
    
    name: r'manufacturer',
    required: false,
    includeIfNull: false,
  )


  final String? manufacturer;



  @JsonKey(
    
    name: r'model',
    required: false,
    includeIfNull: false,
  )


  final String? model;



  @JsonKey(
    
    name: r'modelVersion',
    required: false,
    includeIfNull: false,
  )


  final String? modelVersion;



  @JsonKey(
    
    name: r'osVersion',
    required: false,
    includeIfNull: false,
  )


  final String? osVersion;



  @JsonKey(
    
    name: r'os',
    required: false,
    includeIfNull: false,
  )


  final String? os;



  @JsonKey(
    
    name: r'extra',
    required: false,
    includeIfNull: false,
  )


  final String? extra;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserDeviceData &&
      other.name == name &&
      other.manufacturer == manufacturer &&
      other.model == model &&
      other.modelVersion == modelVersion &&
      other.osVersion == osVersion &&
      other.os == os &&
      other.extra == extra;

    @override
    int get hashCode =>
        (name == null ? 0 : name.hashCode) +
        (manufacturer == null ? 0 : manufacturer.hashCode) +
        (model == null ? 0 : model.hashCode) +
        (modelVersion == null ? 0 : modelVersion.hashCode) +
        (osVersion == null ? 0 : osVersion.hashCode) +
        (os == null ? 0 : os.hashCode) +
        (extra == null ? 0 : extra.hashCode);

  factory UserDeviceData.fromJson(Map<String, dynamic> json) => _$UserDeviceDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDeviceDataToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


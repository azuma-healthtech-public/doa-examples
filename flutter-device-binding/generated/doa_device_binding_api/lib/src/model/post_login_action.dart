//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:doa_device_binding_api/src/model/post_login_action_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_login_action.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PostLoginAction {
  /// Returns a new [PostLoginAction] instance.
  PostLoginAction({

     this.actionType,
  });

  @JsonKey(
    
    name: r'actionType',
    required: false,
    includeIfNull: false,
  )


  final PostLoginActionType? actionType;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PostLoginAction &&
      other.actionType == actionType;

    @override
    int get hashCode =>
        actionType.hashCode;

  factory PostLoginAction.fromJson(Map<String, dynamic> json) => _$PostLoginActionFromJson(json);

  Map<String, dynamic> toJson() => _$PostLoginActionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


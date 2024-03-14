import 'package:json_annotation/json_annotation.dart';
import 'package:redting/features/profile/domain/models/user_phones.dart';

part 'user_phones_entity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class UserPhoneEntity implements UserPhone {
  static const userPhonesCollectionIdFieldName = "userId";
  @override
  String phoneNumber;

  @override
  String userId;

  UserPhoneEntity({
    required this.userId,
    required this.phoneNumber,
  });

  @override
  factory UserPhoneEntity.fromJson(Map<String, dynamic> json) =>
      _$UserPhoneEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserPhoneEntityToJson(this);
}

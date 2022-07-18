import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:redting/core/data/hive_type_ids.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';

part 'auth_user_entity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@HiveType(typeId: authUserTypeId)
class AuthUserEntity implements AuthUser {
  @HiveField(0)
  @override
  String phoneNumber;

  @HiveField(1)
  @override
  String userId;

  AuthUserEntity({required this.userId, required this.phoneNumber});

  factory AuthUserEntity.fromJson(Map<String, dynamic> json) =>
      _$AuthUserEntityFromJson(json);
  Map<String, dynamic> toJson() => _$AuthUserEntityToJson(this);

  @override
  bool isSameAs(AuthUser user) {
    return user.userId == userId;
  }
}

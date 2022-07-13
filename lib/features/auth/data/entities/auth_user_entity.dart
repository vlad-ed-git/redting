import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:redting/core/data/hive_type_ids.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';

part 'auth_user_entity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@HiveType(typeId: auth_user_type_id)
class AuthUserEntity extends AuthUser {
  AuthUserEntity(@HiveField(0) String userId, @HiveField(1) String phoneNumber)
      : super(userId: userId, phoneNumber: phoneNumber);

  factory AuthUserEntity.fromJson(Map<String, dynamic> json) =>
      _$AuthUserEntityFromJson(json);
  Map<String, dynamic> toJson() => _$AuthUserEntityToJson(this);
}

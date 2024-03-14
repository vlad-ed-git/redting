import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:redting/core/utils/flutter_fire_date_time_utils.dart';
import 'package:redting/features/matching/domain/models/liked_user.dart';

part 'liked_user_entity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class LikedUserEntity implements LikedUser {
  @override
  String likedByUserId;

  @TimestampConverter()
  @override
  DateTime likedOn;

  @override
  String likedUserId;

  LikedUserEntity({
    required this.likedByUserId,
    required this.likedOn,
    required this.likedUserId,
  });

  @override
  factory LikedUserEntity.fromJson(Map<String, dynamic> json) =>
      _$LikedUserEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LikedUserEntityToJson(this);

  @override
  LikedUser fromJson(Map<String, dynamic> json) {
    return LikedUserEntity.fromJson(json);
  }
}

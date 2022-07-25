import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:redting/core/data/hive_type_ids.dart';
import 'package:redting/core/utils/flutter_fire_date_time_utils.dart';
import 'package:redting/features/home/domain/models/like_notification.dart';

part 'like_notification_entity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@HiveType(typeId: likeNotificationTypeId)
class LikeNotificationEntity implements LikeNotification {
  @HiveField(0)
  @override
  String likedByUserId;

  @HiveField(1)
  @TimestampConverter()
  @override
  DateTime likedOn;

  @HiveField(2)
  @override
  String likedUserId;

  @HiveField(3)
  @override
  String iceBreaker;

  LikeNotificationEntity(
      {required this.likedByUserId,
      required this.likedOn,
      required this.likedUserId,
      required this.iceBreaker});

  @override
  factory LikeNotificationEntity.fromJson(Map<String, dynamic> json) =>
      _$LikeNotificationEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LikeNotificationEntityToJson(this);

  @override
  LikeNotification fromJson(Map<String, dynamic> json) {
    return LikeNotificationEntity.fromJson(json);
  }
}

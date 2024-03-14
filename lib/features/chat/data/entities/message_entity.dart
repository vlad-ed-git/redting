import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:redting/core/data/hive_type_ids.dart';
import 'package:redting/core/utils/flutter_fire_date_time_utils.dart';
import 'package:redting/features/chat/domain/models/message.dart';

part 'message_entity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@HiveType(typeId: messageTypeId)
class MessageEntity implements Message {
  @HiveField(0)
  @override
  String? imageUrl;

  @HiveField(1)
  @override
  bool isImage;

  @HiveField(2)
  @override
  bool isTxt;

  @HiveField(3)
  @override
  String? message;

  @HiveField(4)
  @TimestampConverter()
  @override
  DateTime sentAt;

  @HiveField(5)
  @override
  String sentBy;

  @HiveField(6)
  @override
  String sentTo;

  @HiveField(7)
  @override
  String uid;

  @HiveField(8)
  @override
  String chatRoomId;

  static String orderByFieldName = "sentAt";

  MessageEntity(
      {required this.uid,
      required this.isImage,
      required this.isTxt,
      required this.sentBy,
      required this.sentTo,
      required this.sentAt,
      this.message,
      this.imageUrl,
      required this.chatRoomId});

  @override
  factory MessageEntity.fromJson(Map<String, dynamic> json) =>
      _$MessageEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MessageEntityToJson(this);

  @override
  MessageEntity fromJson(Map<String, dynamic> json) {
    return MessageEntity.fromJson(json);
  }
}

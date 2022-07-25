// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_notification_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LikeNotificationEntityAdapter
    extends TypeAdapter<LikeNotificationEntity> {
  @override
  final int typeId = 8;

  @override
  LikeNotificationEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LikeNotificationEntity(
      likedByUserId: fields[0] as String,
      likedOn: fields[1] as DateTime,
      likedUserId: fields[2] as String,
      iceBreaker: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LikeNotificationEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.likedByUserId)
      ..writeByte(1)
      ..write(obj.likedOn)
      ..writeByte(2)
      ..write(obj.likedUserId)
      ..writeByte(3)
      ..write(obj.iceBreaker);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LikeNotificationEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeNotificationEntity _$LikeNotificationEntityFromJson(Map json) =>
    LikeNotificationEntity(
      likedByUserId: json['likedByUserId'] as String,
      likedOn:
          const TimestampConverter().fromJson(json['likedOn'] as Timestamp),
      likedUserId: json['likedUserId'] as String,
      iceBreaker: json['iceBreaker'] as String,
    );

Map<String, dynamic> _$LikeNotificationEntityToJson(
        LikeNotificationEntity instance) =>
    <String, dynamic>{
      'likedByUserId': instance.likedByUserId,
      'likedOn': const TimestampConverter().toJson(instance.likedOn),
      'likedUserId': instance.likedUserId,
      'iceBreaker': instance.iceBreaker,
    };

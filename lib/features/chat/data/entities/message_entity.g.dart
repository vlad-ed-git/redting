// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageEntityAdapter extends TypeAdapter<MessageEntity> {
  @override
  final int typeId = 7;

  @override
  MessageEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageEntity(
      uid: fields[7] as String,
      isImage: fields[1] as bool,
      isTxt: fields[2] as bool,
      sentBy: fields[5] as String,
      sentTo: fields[6] as String,
      sentAt: fields[4] as DateTime,
      message: fields[3] as String?,
      imageUrl: fields[0] as String?,
      chatRoomId: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MessageEntity obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.imageUrl)
      ..writeByte(1)
      ..write(obj.isImage)
      ..writeByte(2)
      ..write(obj.isTxt)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.sentAt)
      ..writeByte(5)
      ..write(obj.sentBy)
      ..writeByte(6)
      ..write(obj.sentTo)
      ..writeByte(7)
      ..write(obj.uid)
      ..writeByte(8)
      ..write(obj.chatRoomId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageEntity _$MessageEntityFromJson(Map json) => MessageEntity(
      uid: json['uid'] as String,
      isImage: json['isImage'] as bool,
      isTxt: json['isTxt'] as bool,
      sentBy: json['sentBy'] as String,
      sentTo: json['sentTo'] as String,
      sentAt: const TimestampConverter().fromJson(json['sentAt'] as Timestamp),
      message: Message.decryptMsg(json['message'] as String?),
      imageUrl: json['imageUrl'] as String?,
      chatRoomId: json['chatRoomId'] as String,
    );

Map<String, dynamic> _$MessageEntityToJson(MessageEntity instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'isImage': instance.isImage,
      'isTxt': instance.isTxt,
      'message': instance.message,
      'sentAt': const TimestampConverter().toJson(instance.sentAt),
      'sentBy': instance.sentBy,
      'sentTo': instance.sentTo,
      'uid': instance.uid,
      'chatRoomId': instance.chatRoomId,
    };

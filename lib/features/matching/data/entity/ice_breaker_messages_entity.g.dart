// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ice_breaker_messages_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IceBreakerMessagesEntityAdapter
    extends TypeAdapter<IceBreakerMessagesEntity> {
  @override
  final int typeId = 7;

  @override
  IceBreakerMessagesEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IceBreakerMessagesEntity(
      messages: (fields[0] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, IceBreakerMessagesEntity obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IceBreakerMessagesEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IceBreakerMessagesEntity _$IceBreakerMessagesEntityFromJson(Map json) =>
    IceBreakerMessagesEntity(
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$IceBreakerMessagesEntityToJson(
        IceBreakerMessagesEntity instance) =>
    <String, dynamic>{
      'messages': instance.messages,
    };

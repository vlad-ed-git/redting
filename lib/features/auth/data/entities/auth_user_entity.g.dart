// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthUserEntityAdapter extends TypeAdapter<AuthUserEntity> {
  @override
  final int typeId = 1;

  @override
  AuthUserEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthUserEntity(
      userId: fields[1] as String,
      phoneNumber: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AuthUserEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.phoneNumber)
      ..writeByte(1)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUserEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUserEntity _$AuthUserEntityFromJson(Map json) => AuthUserEntity(
      userId: json['userId'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );

Map<String, dynamic> _$AuthUserEntityToJson(AuthUserEntity instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'userId': instance.userId,
    };

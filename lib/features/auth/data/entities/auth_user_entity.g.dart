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
      fields[0] as String,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AuthUserEntity obj) {
    writer.writeByte(0);
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
      json['userId'] as String,
      json['phoneNumber'] as String,
    );

Map<String, dynamic> _$AuthUserEntityToJson(AuthUserEntity instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'phoneNumber': instance.phoneNumber,
    };

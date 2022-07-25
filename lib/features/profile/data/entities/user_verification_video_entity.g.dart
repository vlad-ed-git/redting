// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_verification_video_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserVerificationVideoEntityAdapter
    extends TypeAdapter<UserVerificationVideoEntity> {
  @override
  final int typeId = 4;

  @override
  UserVerificationVideoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserVerificationVideoEntity(
      userId: fields[0] as String,
      verificationCode: fields[1] as String,
      videoUrl: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserVerificationVideoEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.verificationCode)
      ..writeByte(2)
      ..write(obj.videoUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserVerificationVideoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVerificationVideoEntity _$UserVerificationVideoEntityFromJson(Map json) =>
    UserVerificationVideoEntity(
      userId: json['userId'] as String,
      verificationCode: json['verificationCode'] as String,
      videoUrl: json['videoUrl'] as String,
    );

Map<String, dynamic> _$UserVerificationVideoEntityToJson(
        UserVerificationVideoEntity instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'verificationCode': instance.verificationCode,
      'videoUrl': instance.videoUrl,
    };
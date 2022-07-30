// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileEntityAdapter extends TypeAdapter<UserProfileEntity> {
  @override
  final int typeId = 3;

  @override
  UserProfileEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileEntity(
        name: fields[0] as String,
        userId: fields[1] as String,
        profilePhotoUrl: fields[2] as String,
        genderOther: fields[3] as String?,
        gender: fields[4] as UserGenderEntity,
        bio: fields[5] as String,
        registerCountry: fields[6] as String,
        title: fields[7] as String,
        createdOn: fields[8] as DateTime,
        lastUpdatedOn: fields[9] as DateTime,
        birthDay: fields[10] as DateTime,
        isBanned: fields[11] as bool,
        verificationVideo: fields[12] as UserVerificationVideo,
        age: fields[13] as int);
  }

  @override
  void write(BinaryWriter writer, UserProfileEntity obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.profilePhotoUrl)
      ..writeByte(3)
      ..write(obj.genderOther)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.bio)
      ..writeByte(6)
      ..write(obj.registerCountry)
      ..writeByte(7)
      ..write(obj.title)
      ..writeByte(8)
      ..write(obj.createdOn)
      ..writeByte(9)
      ..write(obj.lastUpdatedOn)
      ..writeByte(10)
      ..write(obj.birthDay)
      ..writeByte(11)
      ..write(obj.isBanned)
      ..writeByte(12)
      ..write(obj.verificationVideo)
      ..writeByte(13)
      ..write(obj.age);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileEntity _$UserProfileEntityFromJson(Map json) => UserProfileEntity(
    name: json['name'] as String,
    userId: json['userId'] as String,
    profilePhotoUrl: json['profilePhotoUrl'] as String,
    genderOther: json['genderOther'] as String?,
    bio: json['bio'] as String,
    registerCountry: json['registerCountry'] as String,
    title: json['title'] as String,
    createdOn:
        const TimestampConverter().fromJson(json['createdOn'] as Timestamp),
    lastUpdatedOn:
        const TimestampConverter().fromJson(json['lastUpdatedOn'] as Timestamp),
    birthDay:
        const TimestampConverter().fromJson(json['birthDay'] as Timestamp),
    isBanned: json['isBanned'] as bool,
    gender: $enumDecode(userGenderEntityToStringVal, json['gender']),
    verificationVideo: UserVerificationVideoEntity.fromJson(
        Map<String, dynamic>.from(json['verificationVideo'] as Map)),
    age: json['age'] as int);

Map<String, dynamic> _$UserProfileEntityToJson(UserProfileEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'userId': instance.userId,
      'profilePhotoUrl': instance.profilePhotoUrl,
      'genderOther': instance.genderOther,
      'gender': userGenderToStringVal[instance.getGender()],
      'bio': instance.bio,
      'registerCountry': instance.registerCountry,
      'title': instance.title,
      'createdOn': const TimestampConverter().toJson(instance.createdOn),
      'lastUpdatedOn':
          const TimestampConverter().toJson(instance.lastUpdatedOn),
      'birthDay': const TimestampConverter().toJson(instance.birthDay),
      'isBanned': instance.isBanned,
      'verificationVideo': instance.verificationVideo.toJson(),
      'age': instance.age
    };

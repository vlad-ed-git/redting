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
      phoneNumber: fields[2] as String,
      profilePhotoUrl: fields[3] as String,
      genderOther: fields[4] as String?,
      bio: fields[6] as String,
      registerCountry: fields[7] as String,
      title: fields[8] as String,
      createdOn: fields[9] as DateTime,
      lastUpdatedOn: fields[10] as DateTime,
      birthDay: fields[11] as DateTime,
      isBanned: fields[12] as bool,
      gender: fields[5] as UserGenderEntity,
      verificationVideo: (fields[13] as Map?)?.cast<DateTime, String>(),
    );
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
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.profilePhotoUrl)
      ..writeByte(4)
      ..write(obj.genderOther)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.bio)
      ..writeByte(7)
      ..write(obj.registerCountry)
      ..writeByte(8)
      ..write(obj.title)
      ..writeByte(9)
      ..write(obj.createdOn)
      ..writeByte(10)
      ..write(obj.lastUpdatedOn)
      ..writeByte(11)
      ..write(obj.birthDay)
      ..writeByte(12)
      ..write(obj.isBanned)
      ..writeByte(13)
      ..write(obj.verificationVideo);
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
      phoneNumber: json['phoneNumber'] as String,
      profilePhotoUrl: json['profilePhotoUrl'] as String,
      genderOther: json['genderOther'] as String?,
      bio: json['bio'] as String,
      registerCountry: json['registerCountry'] as String,
      title: json['title'] as String,
      createdOn:
          const TimestampConverter().fromJson(json['createdOn'] as Timestamp),
      lastUpdatedOn: const TimestampConverter()
          .fromJson(json['lastUpdatedOn'] as Timestamp),
      birthDay:
          const TimestampConverter().fromJson(json['birthDay'] as Timestamp),
      isBanned: json['isBanned'] as bool,
      gender: $enumDecode(_$UserGenderEntityEnumMap, json['gender']),
      verificationVideo: (json['verificationVideo'] as Map?)?.map(
        (k, e) => MapEntry(DateTime.parse(k as String), e as String),
      ),
    );

Map<String, dynamic> _$UserProfileEntityToJson(UserProfileEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'userId': instance.userId,
      'phoneNumber': instance.phoneNumber,
      'profilePhotoUrl': instance.profilePhotoUrl,
      'genderOther': instance.genderOther,
      'gender': _$UserGenderEnumMap[instance.gender]!,
      'bio': instance.bio,
      'registerCountry': instance.registerCountry,
      'title': instance.title,
      'createdOn': const TimestampConverter().toJson(instance.createdOn),
      'lastUpdatedOn':
          const TimestampConverter().toJson(instance.lastUpdatedOn),
      'birthDay': const TimestampConverter().toJson(instance.birthDay),
      'isBanned': instance.isBanned,
      'verificationVideo': instance.verificationVideo
          .map((k, e) => MapEntry(k.toIso8601String(), e)),
    };

const _$UserGenderEntityEnumMap = {
  UserGenderEntity.male: 'male',
  UserGenderEntity.female: 'female',
  UserGenderEntity.stated: 'stated',
};

const _$UserGenderEnumMap = {
  UserGender.male: 'male',
  UserGender.female: 'female',
  UserGender.stated: 'stated',
};

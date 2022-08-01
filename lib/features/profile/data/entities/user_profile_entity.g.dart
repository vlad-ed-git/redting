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
      genderOther: fields[5] as String?,
      gender: fields[18] as UserGenderEntity,
      name: fields[11] as String,
      profilePhotoUrl: fields[13] as String,
      registerCountry: fields[14] as String,
      title: fields[15] as String,
      isBanned: fields[6] as bool,
      age: fields[0] as int,
      bio: fields[1] as String,
      birthDay: fields[2] as DateTime,
      createdOn: fields[3] as DateTime,
      verificationVideo: fields[20] as UserVerificationVideoEntity,
      lastUpdatedOn: fields[7] as DateTime,
      makeMyOrientationPublic: fields[8] as bool,
      onlyShowMeOthersOfSameOrientation: fields[12] as bool,
      maxAgePreference: fields[9] as int,
      minAgePreference: fields[10] as int,
      datingPhotos: (fields[4] as List?)?.cast<String>(),
      sexualOrientation: (fields[17] as List?)?.cast<SexualOrientationEntity>(),
      userId: fields[16] as String,
      genderPreferences: fields[19] as UserGenderEntity?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileEntity obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.age)
      ..writeByte(1)
      ..write(obj.bio)
      ..writeByte(2)
      ..write(obj.birthDay)
      ..writeByte(3)
      ..write(obj.createdOn)
      ..writeByte(4)
      ..write(obj.datingPhotos)
      ..writeByte(5)
      ..write(obj.genderOther)
      ..writeByte(6)
      ..write(obj.isBanned)
      ..writeByte(7)
      ..write(obj.lastUpdatedOn)
      ..writeByte(8)
      ..write(obj.makeMyOrientationPublic)
      ..writeByte(9)
      ..write(obj.maxAgePreference)
      ..writeByte(10)
      ..write(obj.minAgePreference)
      ..writeByte(11)
      ..write(obj.name)
      ..writeByte(12)
      ..write(obj.onlyShowMeOthersOfSameOrientation)
      ..writeByte(13)
      ..write(obj.profilePhotoUrl)
      ..writeByte(14)
      ..write(obj.registerCountry)
      ..writeByte(15)
      ..write(obj.title)
      ..writeByte(16)
      ..write(obj.userId)
      ..writeByte(17)
      ..write(obj.sexualOrientation)
      ..writeByte(18)
      ..write(obj.gender)
      ..writeByte(19)
      ..write(obj.genderPreferences)
      ..writeByte(20)
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
      genderOther: json['genderOther'] as String?,
      gender: $enumDecode(_$UserGenderEntityEnumMap, json['gender']),
      name: json['name'] as String,
      profilePhotoUrl: json['profilePhotoUrl'] as String,
      registerCountry: json['registerCountry'] as String,
      title: json['title'] as String,
      isBanned: json['isBanned'] as bool,
      age: json['age'] as int,
      bio: json['bio'] as String,
      birthDay: DateTime.parse(json['birthDay'] as String),
      createdOn: DateTime.parse(json['createdOn'] as String),
      verificationVideo: UserVerificationVideoEntity.fromJson(
          Map<String, dynamic>.from(json['verificationVideo'] as Map)),
      lastUpdatedOn: DateTime.parse(json['lastUpdatedOn'] as String),
      makeMyOrientationPublic:
          json['makeMyOrientationPublic'] as bool? ?? false,
      onlyShowMeOthersOfSameOrientation:
          json['onlyShowMeOthersOfSameOrientation'] as bool? ?? true,
      maxAgePreference: json['maxAgePreference'] as int? ?? 60,
      minAgePreference: json['minAgePreference'] as int? ?? 18,
      datingPhotos: (json['datingPhotos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sexualOrientation: (json['sexualOrientation'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$SexualOrientationEntityEnumMap, e))
          .toList(),
      userId: json['userId'] as String? ?? "",
      genderPreferences: $enumDecodeNullable(
          _$UserGenderEntityEnumMap, json['genderPreferences']),
    );

Map<String, dynamic> _$UserProfileEntityToJson(UserProfileEntity instance) =>
    <String, dynamic>{
      'age': instance.age,
      'bio': instance.bio,
      'birthDay': instance.birthDay.toIso8601String(),
      'createdOn': instance.createdOn.toIso8601String(),
      'datingPhotos': instance.datingPhotos,
      'genderOther': instance.genderOther,
      'isBanned': instance.isBanned,
      'lastUpdatedOn': instance.lastUpdatedOn.toIso8601String(),
      'makeMyOrientationPublic': instance.makeMyOrientationPublic,
      'maxAgePreference': instance.maxAgePreference,
      'minAgePreference': instance.minAgePreference,
      'name': instance.name,
      'onlyShowMeOthersOfSameOrientation':
          instance.onlyShowMeOthersOfSameOrientation,
      'profilePhotoUrl': instance.profilePhotoUrl,
      'registerCountry': instance.registerCountry,
      'title': instance.title,
      'userId': instance.userId,
      'sexualOrientation': instance.sexualOrientation
          .map((e) => _$SexualOrientationEntityEnumMap[e]!)
          .toList(),
      'gender': _$UserGenderEntityEnumMap[instance.gender]!,
      'genderPreferences':
          _$UserGenderEntityEnumMap[instance.genderPreferences],
      'verificationVideo': instance.verificationVideo.toJson(),
    };

const _$UserGenderEntityEnumMap = {
  UserGenderEntity.male: 'male',
  UserGenderEntity.female: 'female',
  UserGenderEntity.stated: 'stated',
};

const _$SexualOrientationEntityEnumMap = {
  SexualOrientationEntity.straight: 'straight',
  SexualOrientationEntity.gay: 'gay',
  SexualOrientationEntity.asexual: 'asexual',
  SexualOrientationEntity.bisexual: 'bisexual',
  SexualOrientationEntity.demiSexual: 'demiSexual',
  SexualOrientationEntity.panSexual: 'panSexual',
  SexualOrientationEntity.queer: 'queer',
  SexualOrientationEntity.questioning: 'questioning',
};

const _$UserGenderModelEnumMap = {
  UserGender.male: 'male',
  UserGender.female: 'female',
  UserGender.stated: 'stated',
};

const _$SexualOrientationModelEnumMap = {
  SexualOrientation.straight: 'straight',
  SexualOrientation.gay: 'gay',
  SexualOrientation.asexual: 'asexual',
  SexualOrientation.bisexual: 'bisexual',
  SexualOrientation.demiSexual: 'demiSexual',
  SexualOrientation.panSexual: 'panSexual',
  SexualOrientation.queer: 'queer',
  SexualOrientation.questioning: 'questioning',
};

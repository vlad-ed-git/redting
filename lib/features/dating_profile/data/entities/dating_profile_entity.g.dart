// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dating_profile_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DatingProfileEntityAdapter extends TypeAdapter<DatingProfileEntity> {
  @override
  final int typeId = 6;

  @override
  DatingProfileEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DatingProfileEntity(
      maxAgePreference: fields[0] as int,
      minAgePreference: fields[1] as int,
      photos: (fields[2] as List).cast<String>(),
      userId: fields[3] as String,
      genderPreference: fields[4] as UserGenderEntity?,
      makeMyOrientationPublic: fields[6] as bool,
      onlyShowMeOthersOfSameOrientation: fields[7] as bool,
    )..userSexualOrientation =
        (fields[5] as List).cast<SexualOrientationEntity>();
  }

  @override
  void write(BinaryWriter writer, DatingProfileEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.maxAgePreference)
      ..writeByte(1)
      ..write(obj.minAgePreference)
      ..writeByte(2)
      ..write(obj.photos)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.genderPreference)
      ..writeByte(5)
      ..write(obj.userSexualOrientation)
      ..writeByte(6)
      ..write(obj.makeMyOrientationPublic)
      ..writeByte(7)
      ..write(obj.onlyShowMeOthersOfSameOrientation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatingProfileEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DatingProfileEntity _$DatingProfileEntityFromJson(Map json) =>
    DatingProfileEntity(
      maxAgePreference: json['maxAgePreference'] as int,
      minAgePreference: json['minAgePreference'] as int,
      photos:
          (json['photos'] as List<dynamic>).map((e) => e as String).toList(),
      userId: json['userId'] as String,
      genderPreference: $enumDecodeNullable(
          _$UserGenderEntityEnumMap, json['genderPreference']),
      makeMyOrientationPublic: json['makeMyOrientationPublic'] as bool,
      onlyShowMeOthersOfSameOrientation:
          json['onlyShowMeOthersOfSameOrientation'] as bool,
    )..userSexualOrientation = (json['userSexualOrientation'] as List<dynamic>)
        .map((e) => $enumDecode(_$SexualOrientationEntityEnumMap, e))
        .toList();

Map<String, dynamic> _$DatingProfileEntityToJson(
        DatingProfileEntity instance) =>
    <String, dynamic>{
      'maxAgePreference': instance.maxAgePreference,
      'minAgePreference': instance.minAgePreference,
      'photos': instance.photos,
      'userId': instance.userId,
      'genderPreference': _$UserGenderEntityEnumMap[instance.genderPreference],
      'userSexualOrientation': instance.userSexualOrientation
          .map((e) => _$SexualOrientationEntityEnumMap[e]!)
          .toList(),
      'makeMyOrientationPublic': instance.makeMyOrientationPublic,
      'onlyShowMeOthersOfSameOrientation':
          instance.onlyShowMeOthersOfSameOrientation,
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

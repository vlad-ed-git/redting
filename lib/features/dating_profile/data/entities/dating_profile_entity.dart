import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:redting/core/data/hive_type_ids.dart';
import 'package:redting/features/dating_profile/data/entities/sexual_orientation_entity.dart';
import 'package:redting/features/dating_profile/data/utils/enum_mappers.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/dating_profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/profile/data/entities/user_gender_entity.dart';
import 'package:redting/features/profile/data/utils/enum_mappers.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';

part 'dating_profile_entity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@HiveType(typeId: datingProfileTypeId)
class DatingProfileEntity implements DatingProfile {
  @HiveField(0)
  @override
  int maxAgePreference;

  @HiveField(1)
  @override
  int minAgePreference;

  @HiveField(2)
  @override
  List<String> photos;

  @HiveField(3)
  @override
  String userId;

  @HiveField(4)
  UserGenderEntity? genderPreference;

  @HiveField(5)
  List<SexualOrientationEntity> userSexualOrientation;

  @HiveField(6)
  @override
  bool makeMyOrientationPublic;

  @HiveField(7)
  @override
  bool onlyShowMeOthersOfSameOrientation;

  DatingProfileEntity(
      {required this.maxAgePreference,
      required this.minAgePreference,
      required this.photos,
      required this.userId,
      required this.genderPreference,
      List<SexualOrientationEntity>? userOrientation,
      required this.makeMyOrientationPublic,
      required this.onlyShowMeOthersOfSameOrientation})
      : userSexualOrientation = userOrientation ?? [];

  @override
  factory DatingProfileEntity.fromJson(Map<String, dynamic> json) =>
      _$DatingProfileEntityFromJson(json);

  @override
  DatingProfile fromJson(Map<String, dynamic> json) {
    return DatingProfileEntity.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$DatingProfileEntityToJson(this);

  @override
  UserGender? getGenderPreferences() {
    return genderPreference != null
        ? mapUserGenderEntityToDomainModel(genderPreference!)
        : null;
  }

  @override
  setGenderPreference(UserGender? preferences) {
    genderPreference =
        preferences != null ? mapUserGenderToDataEntity(preferences) : null;
  }

  @override
  List<SexualOrientation> getUserSexualOrientation() {
    return userSexualOrientation
        .map((entity) => mapSexualOrientationEntityToModel(entity))
        .toList();
  }

  @override
  bool isSameAs(DatingProfile datingProfile) {
    return userId == datingProfile.userId;
  }

  @override
  setUserSexualOrientation(List<SexualOrientation> userOrientationModel) {
    userSexualOrientation = userOrientationModel
        .map((e) => mapSexualOrientationToEntity(e))
        .toList();
  }
}

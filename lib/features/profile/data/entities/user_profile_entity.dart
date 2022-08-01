import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:redting/core/data/hive_type_ids.dart';
import 'package:redting/features/profile/data/entities/sexual_orientation_entity.dart';
import 'package:redting/features/profile/data/entities/user_gender_entity.dart';
import 'package:redting/features/profile/data/entities/user_verification_video_entity.dart';
import 'package:redting/features/profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';

part 'user_profile_entity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@HiveType(typeId: userProfileTypeId)
class UserProfileEntity implements UserProfile {
  static String ageFieldName = "age";
  static String genderFieldName = "gender";
  static String isBannedFieldName = "isBanned";
  static String genderPreferencesFieldName = "genderPreferences";
  static String sexualOrientationFieldName = "sexualOrientation";
  static String onlyShowMeOthersOfSameOrientationFieldName =
      "onlyShowMeOthersOfSameOrientation";
  static String minAgePreferenceFieldName = "minAgePreference";
  static String maxAgePreferenceFieldName = "maxAgePreference";

  @HiveField(0)
  @override
  int age;

  @HiveField(1)
  @override
  String bio;

  @HiveField(2)
  @override
  DateTime birthDay;

  @HiveField(3)
  @override
  DateTime createdOn;

  @HiveField(4)
  @override
  List<String> datingPhotos;

  @HiveField(5)
  @override
  String? genderOther;

  @HiveField(6)
  @override
  bool isBanned;

  @HiveField(7)
  @override
  DateTime lastUpdatedOn;

  @HiveField(8)
  @override
  bool makeMyOrientationPublic;

  @HiveField(9)
  @override
  int maxAgePreference;

  @HiveField(10)
  @override
  int minAgePreference;

  @HiveField(11)
  @override
  String name;

  @HiveField(12)
  @override
  bool onlyShowMeOthersOfSameOrientation;

  @HiveField(13)
  @override
  String profilePhotoUrl;

  @HiveField(14)
  @override
  String registerCountry;

  @HiveField(15)
  @override
  String title;

  @HiveField(16)
  @override
  String userId;

  @HiveField(17)
  List<SexualOrientationEntity> sexualOrientation;

  @HiveField(18)
  UserGenderEntity gender;

  @HiveField(19)
  UserGenderEntity? genderPreferences;

  @HiveField(20)
  UserVerificationVideoEntity verificationVideo;

  UserProfileEntity(
      {required this.genderOther,
      required this.gender,
      required this.name,
      required this.profilePhotoUrl,
      required this.registerCountry,
      required this.title,
      required this.isBanned,
      required this.age,
      required this.bio,
      required this.birthDay,
      required this.createdOn,
      required this.verificationVideo,
      required this.lastUpdatedOn,
      this.makeMyOrientationPublic = false,
      this.onlyShowMeOthersOfSameOrientation = true,
      this.maxAgePreference = 60,
      this.minAgePreference = 18,
      List<String>? datingPhotos,
      List<SexualOrientationEntity>? sexualOrientation,
      this.userId = "",
      this.genderPreferences})
      : datingPhotos = datingPhotos ?? [],
        sexualOrientation =
            sexualOrientation ?? [SexualOrientationEntity.straight];

  @override
  UserGender getGender() {
    return genderEntityToGenderModel(gender);
  }

  @override
  UserGender? getGenderPreferences() {
    if (genderPreferences == null) return null;
    return genderEntityToGenderModel(genderPreferences!);
  }

  @override
  List<SexualOrientation> getUserSexualOrientation() {
    return sexualOrientation
        .map((e) => sexualOrientationEntityToModel(e))
        .toList();
  }

  @override
  UserVerificationVideo getVerificationVideo() {
    return verificationVideo;
  }

  @override
  bool isSameAs(UserProfile user) {
    return userId == user.userId;
  }

  @override
  factory UserProfileEntity.fromJson(Map<String, dynamic> json) =>
      _$UserProfileEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserProfileEntityToJson(this);

  @override
  UserProfile fromJson(Map<String, dynamic> json) {
    return UserProfileEntity.fromJson(json);
  }

  @override
  setGender(UserGender genderModel) {
    gender = genderModelToGenderEntity(genderModel);
  }

  @override
  setGenderPreferences(UserGender? gender) {
    genderPreferences =
        gender != null ? genderModelToGenderEntity(gender) : null;
  }

  @override
  setUserSexualOrientation(List<SexualOrientation> orientation) {
    sexualOrientation =
        orientation.map((e) => sexualOrientationModelToEntity(e)).toList();
  }

  @override
  setVerificationVideo(UserVerificationVideo video) {
    verificationVideo = mapUserVerificationVideoModelToEntity(video);
  }
}

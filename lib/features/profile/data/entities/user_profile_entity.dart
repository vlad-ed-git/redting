import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:redting/core/data/hive_type_ids.dart';
import 'package:redting/core/utils/flutter_fire_date_time_utils.dart';
import 'package:redting/features/profile/data/entities/user_gender_entity.dart';
import 'package:redting/features/profile/data/entities/user_verification_video_entity.dart';
import 'package:redting/features/profile/data/utils/enum_mappers.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';

part 'user_profile_entity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@HiveType(typeId: userProfileTypeId)
class UserProfileEntity implements UserProfile {
  @HiveField(0)
  @override
  String name;

  @HiveField(1)
  @override
  String userId;

  @HiveField(2)
  @override
  String profilePhotoUrl;

  @HiveField(3)
  @override
  String? genderOther;

  @HiveField(4)
  UserGenderEntity gender;

  @HiveField(5)
  @override
  String bio;

  @HiveField(6)
  @override
  String registerCountry;

  @HiveField(7)
  @override
  String title;

  @HiveField(8)
  @override
  @TimestampConverter()
  DateTime createdOn;

  @HiveField(9)
  @override
  @TimestampConverter()
  DateTime lastUpdatedOn;

  @HiveField(10)
  @override
  @TimestampConverter()
  DateTime birthDay;

  @HiveField(11)
  @override
  bool isBanned;

  @HiveField(12)
  @override
  UserVerificationVideo verificationVideo;

  @HiveField(13)
  @override
  int age;

  static Object ageFieldName = "age";
  static Object genderFieldName = "gender";
  static Object isBannedFieldName = "isBanned";

  UserProfileEntity(
      {required this.name,
      required this.userId,
      required this.profilePhotoUrl,
      this.genderOther,
      required this.bio,
      required this.registerCountry,
      required this.title,
      required this.createdOn,
      required this.lastUpdatedOn,
      required this.birthDay,
      required this.isBanned,
      required this.gender,
      required this.verificationVideo,
      required this.age});

  @override
  factory UserProfileEntity.fromJson(Map<String, dynamic> json) =>
      _$UserProfileEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserProfileEntityToJson(this);

  @override
  bool isSameAs(UserProfile user) {
    return user.userId == userId;
  }

  @override
  UserProfile fromJson(Map<String, dynamic> json) {
    return UserProfileEntity.fromJson(json);
  }

  @override
  UserGender getGender() {
    return mapUserGenderEntityToDomainModel(gender);
  }

  @override
  setGender(UserGender gender) {
    this.gender = mapUserGenderToDataEntity(gender);
  }
}

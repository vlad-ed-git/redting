import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:redting/core/data/hive_type_ids.dart';
import 'package:redting/core/utils/flutter_fire_date_time_utils.dart';
import 'package:redting/features/profile/data/entities/user_gender_entity.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

part 'user_profile_entity.g.dart';

//todo sexual orientation

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
  String phoneNumber;

  @HiveField(3)
  @override
  String profilePhotoUrl;

  @HiveField(4)
  @override
  String? genderOther;

  @HiveField(5)
  @override
  UserGender gender;

  @HiveField(6)
  @override
  String bio;

  @HiveField(7)
  @override
  String registerCountry;

  @HiveField(8)
  @override
  String title;

  @HiveField(9)
  @override
  @TimestampConverter()
  DateTime createdOn;

  @HiveField(10)
  @override
  @TimestampConverter()
  DateTime lastUpdatedOn;

  @HiveField(11)
  @override
  @TimestampConverter()
  DateTime birthDay;

  @HiveField(12)
  @override
  bool isBanned;

  @HiveField(13)
  @override
  Map<DateTime, String> verificationVideo;

  UserProfileEntity({
    required this.name,
    required this.userId,
    required this.phoneNumber,
    required this.profilePhotoUrl,
    this.genderOther,
    required this.bio,
    required this.registerCountry,
    required this.title,
    required this.createdOn,
    required this.lastUpdatedOn,
    required this.birthDay,
    required this.isBanned,
    required UserGenderEntity gender,
    Map<DateTime, String>? verificationVideo,
  })  : gender = mapUserGenderEntityToDomainModel(gender),
        verificationVideo = verificationVideo ?? {};

  factory UserProfileEntity.fromJson(Map<String, dynamic> json) =>
      _$UserProfileEntityFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileEntityToJson(this);

  @override
  bool isSameAs(UserProfile user) {
    return user.userId == userId;
  }
}

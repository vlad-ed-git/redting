import 'package:redting/core/utils/flutter_fire_date_time_utils.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';

abstract class UserProfile {
  String name;
  String userId;
  String phoneNumber;
  String profilePhotoUrl;
  String? genderOther;
  UserGender gender;
  String bio;
  String registerCountry;
  String title;

  UserVerificationVideo verificationVideo;

  @TimestampConverter()
  DateTime createdOn;

  @TimestampConverter()
  DateTime lastUpdatedOn;

  @TimestampConverter()
  DateTime birthDay;

  bool isBanned;

  UserProfile({
    required this.name,
    required this.userId,
    required this.phoneNumber,
    required this.profilePhotoUrl,
    this.genderOther,
    required this.gender,
    required this.bio,
    required this.registerCountry,
    required this.title,
    required this.createdOn,
    required this.lastUpdatedOn,
    required this.birthDay,
    required this.isBanned,
    required this.verificationVideo,
  });

  bool isSameAs(UserProfile user);
  UserProfile fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}

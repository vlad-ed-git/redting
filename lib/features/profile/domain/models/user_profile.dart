import 'package:redting/core/utils/flutter_fire_date_time_utils.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';

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

  @TimestampConverter()
  Map<DateTime, String> verificationVideo;

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
    Map<DateTime, String>? verificationVideo,
  }) : verificationVideo = verificationVideo ?? {};

  bool isSameAs(UserProfile user);
}

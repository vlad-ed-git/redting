import 'package:redting/core/utils/flutter_fire_date_time_utils.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';

abstract class UserProfile {
  String name;
  String userId;
  String phoneNumber;
  String profilePhotoUrl;
  String? genderOther;
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

  static const int userBioMinLen = 20;
  static const int userBioMaxLen = 120;
  static const int userTitleMinLen = 4;
  static const int userTitleMaxLen = 40;

  UserProfile({
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
    required this.verificationVideo,
  });

  bool isSameAs(UserProfile user);
  UserProfile fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();

  static bool isOfLegalAge({DateTime? birthDay}) {
    if (birthDay == null) return false;
    return (DateTime.now().year - birthDay.year) >= 18;
  }

  static bool isValidGender({required UserGender gender, String? genderOther}) {
    if (gender != UserGender.stated) return true;
    return (genderOther != null) && (genderOther.isEmpty == false);
  }

  UserGender getGender();
  setGender(UserGender gender);
}

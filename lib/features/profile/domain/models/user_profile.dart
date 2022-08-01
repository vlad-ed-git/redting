import 'package:redting/features/profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';

abstract class UserProfile {
  String name;
  String userId;
  String profilePhotoUrl;
  String? genderOther;
  String bio;
  String registerCountry;
  String title;

  DateTime createdOn;

  DateTime lastUpdatedOn;

  DateTime birthDay;

  bool isBanned;
  int age;

  List<String> datingPhotos;
  int minAgePreference;
  int maxAgePreference;
  bool makeMyOrientationPublic;
  bool onlyShowMeOthersOfSameOrientation;

  static const int userBioMinLen = 20;
  static const int userBioMaxLen = 120;
  static const int userTitleMinLen = 4;
  static const int userTitleMaxLen = 40;

  UserProfile(
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
      required this.age,
      required this.datingPhotos,
      required this.minAgePreference,
      required this.maxAgePreference,
      this.makeMyOrientationPublic = true,
      this.onlyShowMeOthersOfSameOrientation = true});

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

  /// OTHER ENUM DATA
  UserGender getGender();
  UserVerificationVideo getVerificationVideo();
  UserGender? getGenderPreferences();
  List<SexualOrientation> getUserSexualOrientation();
  setVerificationVideo(UserVerificationVideo video);
  setGenderPreferences(UserGender? genderPreference);
  setUserSexualOrientation(List<SexualOrientation> orientation);
  setGender(UserGender gender);
}

import 'package:redting/features/dating_profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';

abstract class DatingProfile {
  String userId;
  List<String> photos;
  int minAgePreference;
  int maxAgePreference;
  bool makeMyOrientationPublic;
  bool onlyShowMeOthersOfSameOrientation;

  DatingProfile(
      {required this.userId,
      required this.photos,
      required this.minAgePreference,
      required this.maxAgePreference,
      this.makeMyOrientationPublic = true,
      this.onlyShowMeOthersOfSameOrientation = true});

  bool isSameAs(DatingProfile datingProfile);
  DatingProfile fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();

  UserGender? getGenderPreferences();
  setGenderPreference(UserGender? genderPreferences);

  List<SexualOrientation> getUserSexualOrientation();
  setUserSexualOrientation(List<SexualOrientation> orientation);
}

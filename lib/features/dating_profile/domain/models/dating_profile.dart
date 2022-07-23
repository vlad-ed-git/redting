import 'package:redting/features/dating_profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';

abstract class DatingProfile {
  String userId;
  List<String> photos;
  int minAgePreference;
  int maxAgePreference;

  DatingProfile(
      {required this.userId,
      required this.photos,
      required this.minAgePreference,
      required this.maxAgePreference});

  bool isSameAs(DatingProfile datingProfile);
  DatingProfile fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();

  UserGender? getGenderPreferences();

  List<SexualOrientation> getSexualOrientationPreferences();
  setSexualOrientationPreferences(
      List<SexualOrientation> orientationPreferences);

  SexualOrientation getUserSexualOrientation();
  setUserSexualOrientation(SexualOrientation orientation);
}

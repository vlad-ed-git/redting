import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/dating_profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';

abstract class DatingProfileRepo {
  Future<OperationResult> addPhoto(File photo, String filename, String userId);
  Future<OperationResult> createDatingProfile(
      String userId,
      List<File> photoFiles,
      List<String> photoFileNames,
      int minAgePreference,
      int maxAgePreference,
      UserGender? genderPreference,
      List<SexualOrientation> userOrientation,
      bool makeMyOrientationPublic,
      bool onlyShowMeOthersOfSameOrientation);
  Future<OperationResult> getDatingProfileFromRemote(String userId);
  Future<DatingProfile?> getCachedDatingProfile();
  Future<OperationResult> updateDatingProfile(
      String userId,
      List<String> photos,
      int minAgePreference,
      int maxAgePreference,
      UserGender? genderPreference,
      List<SexualOrientation> userOrientation,
      bool makeMyOrientationPublic,
      bool onlyShowMeOthersOfSameOrientation);
}

import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/repositories/profile_repository.dart';

class AddDatingInfoUseCase {
  final ProfileRepository repository;
  AddDatingInfoUseCase(
    this.repository,
  );

  Future<OperationResult> execute(
      UserProfile profile,
      List<File> photoFiles,
      List<String> photoFileNames,
      int minAgePreference,
      int maxAgePreference,
      UserGender? genderPreference,
      List<SexualOrientation> userOrientation,
      bool makeMyOrientationPublic,
      bool onlyShowMeOthersOfSameOrientation) async {
    return await repository.addDatingInfo(
        profile,
        photoFiles,
        photoFileNames,
        minAgePreference,
        maxAgePreference,
        genderPreference,
        userOrientation,
        makeMyOrientationPublic,
        onlyShowMeOthersOfSameOrientation);
  }
}

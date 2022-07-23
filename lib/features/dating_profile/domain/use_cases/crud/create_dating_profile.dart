import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/dating_profile/domain/repository/dating_profile_repo.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';

class CreateDatingProfileUseCase {
  final DatingProfileRepo _repository;
  CreateDatingProfileUseCase(
    this._repository,
  );

  Future<OperationResult> execute(
      String userId,
      List<File> photoFiles,
      List<String> photoFileNames,
      int minAgePreference,
      int maxAgePreference,
      UserGender? genderPreference,
      List<SexualOrientation> userOrientation,
      bool makeMyOrientationPublic,
      bool onlyShowMeOthersOfSameOrientation) async {
    return await _repository.createDatingProfile(
        userId,
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

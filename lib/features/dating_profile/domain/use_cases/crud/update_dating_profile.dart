import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/dating_profile/domain/repository/dating_profile_repo.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';

class UpdateDatingProfileUseCase {
  final DatingProfileRepo _repository;

  UpdateDatingProfileUseCase(
    this._repository,
  );

  Future<OperationResult> execute(
      String userId,
      List<String> photos,
      int minAgePreference,
      int maxAgePreference,
      UserGender? genderPreference,
      List<SexualOrientation> userOrientation,
      bool makeMyOrientationPublic,
      bool onlyShowMeOthersOfSameOrientation) async {
    return await _repository.updateDatingProfile(
        userId,
        photos,
        minAgePreference,
        maxAgePreference,
        genderPreference,
        userOrientation,
        makeMyOrientationPublic,
        onlyShowMeOthersOfSameOrientation);
  }
}

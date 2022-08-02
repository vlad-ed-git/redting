import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/repositories/profile_repository.dart';
import 'package:redting/features/profile/domain/utils/dating_pic.dart';

class SetDatingInfoUseCase {
  final ProfileRepository repository;
  SetDatingInfoUseCase(
    this.repository,
  );

  Future<OperationResult> execute(
      UserProfile profile,
      List<DatingPic> datingPics,
      int minAgePreference,
      int maxAgePreference,
      UserGender? genderPreference,
      List<SexualOrientation> userOrientation,
      bool makeMyOrientationPublic,
      bool onlyShowMeOthersOfSameOrientation) async {
    return await repository.setDatingInfo(
        profile,
        datingPics,
        minAgePreference,
        maxAgePreference,
        genderPreference,
        userOrientation,
        makeMyOrientationPublic,
        onlyShowMeOthersOfSameOrientation);
  }
}

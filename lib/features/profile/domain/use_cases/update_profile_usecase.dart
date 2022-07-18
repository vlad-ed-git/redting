import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/repositories/ProfileRepository.dart';

class UpdateProfileUseCase {
  final ProfileRepository profileRepository;
  UpdateProfileUseCase({required this.profileRepository});

  Future<OperationResult> execute({
    required UserProfile oldProfile,
    String? name,
    String? profilePhotoUrl,
    String? genderOther,
    UserGender? gender,
    String? bio,
    String? title,
    DateTime? birthDay,
    String? verificationVideoUrl,
  }) async {
    return await profileRepository.updateUserProfile(
        oldProfile: oldProfile,
        name: name,
        profilePhotoUrl: profilePhotoUrl,
        gender: gender,
        genderOther: genderOther,
        bio: bio,
        title: title,
        birthDay: birthDay,
        verificationVideoUrl: verificationVideoUrl);
  }
}

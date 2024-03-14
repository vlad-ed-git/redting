import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';
import 'package:redting/features/profile/domain/repositories/profile_repository.dart';

class CreateProfileUseCase {
  final ProfileRepository profileRepository;
  CreateProfileUseCase({required this.profileRepository});

  Future<ServiceResult> execute({
    required String name,
    required String userId,
    required String profilePhotoUrl,
    String? genderOther,
    required UserGender gender,
    required String bio,
    required String title,
    required DateTime? birthDay,
    required String registerCountry,
    required UserVerificationVideo? verificationVideo,
  }) async {
    return await profileRepository.createUserProfile(
        name: name,
        userId: userId,
        profilePhotoUrl: profilePhotoUrl,
        gender: gender,
        genderOther: genderOther,
        bio: bio,
        title: title,
        registerCountry: registerCountry,
        birthDay: birthDay,
        verificationVideo: verificationVideo);
  }
}

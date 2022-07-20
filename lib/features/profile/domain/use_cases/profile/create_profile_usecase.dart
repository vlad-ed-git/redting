import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';
import 'package:redting/features/profile/domain/repositories/ProfileRepository.dart';

class CreateProfileUseCase {
  final ProfileRepository profileRepository;
  CreateProfileUseCase({required this.profileRepository});

  Future<OperationResult> execute({
    required String name,
    required String userId,
    required String phoneNumber,
    required String profilePhotoUrl,
    String? genderOther,
    required UserGender gender,
    required String bio,
    required String registerCountry,
    required String title,
    required DateTime birthDay,
    bool isBanned = false,
    required UserVerificationVideo verificationVideo,
  }) async {
    return await profileRepository.createUserProfile(
        name: name,
        userId: userId,
        phoneNumber: phoneNumber,
        profilePhotoUrl: profilePhotoUrl,
        gender: gender,
        bio: bio,
        registerCountry: registerCountry,
        title: title,
        birthDay: birthDay,
        verificationVideo: verificationVideo);
  }
}

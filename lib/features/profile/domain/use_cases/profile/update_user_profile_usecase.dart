import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/repositories/profile_repository.dart';

class UpdateUserProfileUseCase {
  final ProfileRepository repository;
  UpdateUserProfileUseCase(this.repository);

  Future<ServiceResult> execute({
    required UserProfile profile,
    required String name,
    required String profilePhotoUrl,
    required String? genderOther,
    required UserGender gender,
    required String bio,
    required String title,
    required DateTime birthDay,
    required String registerCountry,
  }) async {
    return await repository.updateUserProfile(
        profile: profile,
        name: name,
        profilePhotoUrl: profilePhotoUrl,
        genderOther: genderOther,
        gender: gender,
        bio: bio,
        title: title,
        birthDay: birthDay,
        registerCountry: registerCountry);
  }
}

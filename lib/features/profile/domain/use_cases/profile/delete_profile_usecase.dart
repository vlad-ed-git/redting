import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/repositories/ProfileRepository.dart';

class DeleteProfileUseCase {
  final ProfileRepository profileRepository;
  DeleteProfileUseCase({required this.profileRepository});

  Future<OperationResult> execute(UserProfile profile) async {
    return await profileRepository.deleteUserProfile(profile: profile);
  }
}

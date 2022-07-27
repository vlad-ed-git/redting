import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/repositories/ProfileRepository.dart';

class GetCachedProfileUseCase {
  final ProfileRepository profileRepository;
  GetCachedProfileUseCase({required this.profileRepository});

  Future<UserProfile?> execute() async {
    return await profileRepository.getCachedUserProfile();
  }
}

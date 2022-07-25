import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/auth/domain/repositories/auth_repository.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/dating_profile/domain/repository/dating_profile_repo.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/repositories/ProfileRepository.dart';
import 'package:redting/features/splash/domain/current_user_status_util.dart';

class SplashRepository {
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;
  final DatingProfileRepo datingProfileRepo;
  SplashRepository(
      this.authRepository, this.profileRepository, this.datingProfileRepo);

  Future<CurrentUserStatus> fetchCurrentUserStatus() async {
    OperationResult result = await authRepository.getCachedAuthUser();
    if (result.errorOccurred) {
      return CurrentUserStatus(errorFetchingStatus: true);
    }

    if (result.data is! AuthUser) return CurrentUserStatus();

    AuthUser authUser = result.data as AuthUser;
    OperationResult profileResult =
        await profileRepository.getUserProfileFromRemote();
    if (profileResult.errorOccurred) {
      return CurrentUserStatus(errorFetchingStatus: true);
    } else if (profileResult.data is! UserProfile) {
      return CurrentUserStatus(authUser: authUser);
    }

    /// GET DATING PROFILE
    OperationResult datingProfileResult =
        await datingProfileRepo.getDatingProfileFromRemote(authUser.userId);
    if (datingProfileResult.errorOccurred) {
      return CurrentUserStatus(errorFetchingStatus: true);
    } else if (datingProfileResult.data is! DatingProfile) {
      return CurrentUserStatus(
        authUser: authUser,
        profile: profileResult.data,
      );
    }

    return CurrentUserStatus(
        authUser: authUser,
        profile: profileResult.data as UserProfile,
        datingProfile: datingProfileResult.data as DatingProfile);
  }
}

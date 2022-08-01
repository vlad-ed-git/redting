import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/auth/domain/repositories/auth_repository.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/repositories/profile_repository.dart';
import 'package:redting/features/splash/domain/current_user_status_util.dart';

class SplashRepository {
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;
  SplashRepository(
    this.authRepository,
    this.profileRepository,
  );

  Future<CurrentUserStatus> fetchCurrentUserStatus() async {
    OperationResult result = await authRepository.getCachedAuthUser();
    if (result.errorOccurred) {
      //an error occurred
      return CurrentUserStatus(errorFetchingStatus: true);
    }

    if (result.data is! AuthUser) return CurrentUserStatus();

    AuthUser authUser = result.data as AuthUser;
    OperationResult profileResult =
        await profileRepository.loadUserProfileFromRemoteIfExists();
    if (profileResult.errorOccurred) {
      //an error occurred
      return CurrentUserStatus(errorFetchingStatus: true);
    }

    if (profileResult.data is! UserProfile) {
      return CurrentUserStatus(authUser: authUser);
    }

    return CurrentUserStatus(
      authUser: authUser,
      profile: profileResult.data as UserProfile,
    );
  }
}

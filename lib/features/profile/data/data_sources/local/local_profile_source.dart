import 'package:redting/features/profile/domain/models/user_profile.dart';

abstract class LocalProfileDataSource {
  Future<UserProfile?> getCachedUserProfile();
  Future<bool> clearUserProfileCache();
  Future<UserProfile?> updateUserProfileCache({required UserProfile profile});
  Future<UserProfile?> cacheAndReturnUserProfile(
      {required UserProfile profile});
}

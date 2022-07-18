import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

abstract class LocalProfileDataSource {
  Future<UserProfile?> getCachedUserProfile();
  Future<OperationResult> updateUserProfileCache(
      {required UserProfile profile});
  Future<OperationResult> clearUserProfileCache({required UserProfile profile});
  Future<OperationResult> cacheUserProfile({required UserProfile profile});
}
import 'package:hive_flutter/hive_flutter.dart';
import 'package:redting/core/data/hive_names.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/data/data_sources/local/local_profile_source.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

class UserProfileHive implements LocalProfileDataSource {
  final Box _profileHiveBox = Hive.box<UserProfile?>(userProfileBox);

  @override
  Future<OperationResult> cacheUserProfile(
      {required UserProfile profile}) async {
    try {
      await _profileHiveBox.put(userProfileKey, profile);
      return OperationResult();
    } catch (e) {
      return OperationResult(errorMessage: "$e", errorOccurred: true);
    }
  }

  @override
  Future<OperationResult> clearUserProfileCache(
      {required UserProfile profile}) async {
    try {
      await _profileHiveBox.delete(userProfileKey);
      return OperationResult();
    } catch (e) {
      return OperationResult(errorMessage: "$e", errorOccurred: true);
    }
  }

  @override
  Future<OperationResult> updateUserProfileCache(
      {required UserProfile profile}) async {
    try {
      OperationResult result = await clearUserProfileCache(profile: profile);
      if (result.errorOccurred) return result;

      return await cacheUserProfile(profile: profile);
    } catch (e) {
      return OperationResult(errorMessage: "$e", errorOccurred: true);
    }
  }

  @override
  Future<UserProfile?> getCachedUserProfile() async {
    try {
      return _profileHiveBox.get(userProfileKey);
    } catch (e) {
      return null;
    }
  }
}

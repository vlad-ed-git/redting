import 'package:hive_flutter/hive_flutter.dart';
import 'package:redting/core/data/hive_names.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/data/data_sources/local/local_profile_source.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/res/strings.dart';

class UserProfileHive implements LocalProfileDataSource {
  final Box _profileHiveBox = Hive.box<UserProfile?>(userProfileBox);

  @override
  Future<OperationResult> cacheAndReturnUserProfile(
      {required UserProfile profile}) async {
    try {
      await _profileHiveBox.put(userProfileKey, profile);
      return OperationResult(data: profile);
    } catch (e) {
      print("============ $e ===========");
      return OperationResult(
          errorMessage: createProfileError, errorOccurred: true);
    }
  }

  @override
  Future<OperationResult> clearUserProfileCache() async {
    try {
      await _profileHiveBox.delete(userProfileKey);
      return OperationResult();
    } catch (e) {
      print("============ $e ===========");
      return OperationResult(
          errorMessage: deleteProfileError, errorOccurred: true);
    }
  }

  @override
  Future<OperationResult> updateUserProfileCache(
      {required UserProfile profile}) async {
    try {
      OperationResult result = await clearUserProfileCache();
      if (result.errorOccurred) return result;

      return await cacheAndReturnUserProfile(profile: profile);
    } catch (e) {
      print("============ $e ===========");
      return OperationResult(
          errorMessage: updateProfileError, errorOccurred: true);
    }
  }

  @override
  Future<UserProfile?> getCachedUserProfile() async {
    try {
      return await _profileHiveBox.get(userProfileKey) as UserProfile?;
    } catch (e) {
      print("============ $e ===========");
      return null;
    }
  }
}

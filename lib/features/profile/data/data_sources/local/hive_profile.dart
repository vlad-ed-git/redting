import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:redting/core/data/hive_names.dart';
import 'package:redting/features/profile/data/data_sources/local/local_profile_source.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

class UserProfileHive implements LocalProfileDataSource {
  final Box _profileHiveBox = Hive.box<UserProfile?>(userProfileBox);

  @override
  Future<UserProfile?> cacheAndReturnUserProfile(
      {required UserProfile profile}) async {
    try {
      await _profileHiveBox.put(userProfileKey, profile);
      return profile;
    } catch (e) {
      if (kDebugMode) {
        print(
            "============ cacheAndReturnUserProfile exception hive $e ===========");
      }
      return null;
    }
  }

  @override
  Future<bool> clearUserProfileCache() async {
    try {
      await _profileHiveBox.delete(userProfileKey);
      return true; //success
    } catch (e) {
      if (kDebugMode) {
        print(
            "============  clearUserProfileCache exception hive $e ===========");
      }
      return false;
    }
  }

  @override
  Future<UserProfile?> updateUserProfileCache(
      {required UserProfile profile}) async {
    try {
      bool isCleared = await clearUserProfileCache();
      if (!isCleared) return null;
      return await cacheAndReturnUserProfile(profile: profile);
    } catch (e) {
      if (kDebugMode) {
        print(
            "============ updateUserProfileCache exception hive $e ===========");
      }
      return null;
    }
  }

  @override
  Future<UserProfile?> getCachedUserProfile() async {
    try {
      return await _profileHiveBox.get(userProfileKey) as UserProfile?;
    } catch (e) {
      if (kDebugMode) {
        print("============ $e ===========");
      }
      return null;
    }
  }
}

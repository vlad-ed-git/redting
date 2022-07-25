import 'package:hive_flutter/hive_flutter.dart';
import 'package:redting/core/data/hive_names.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/data/data_sources/local/local_dating_profile_source.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/res/strings.dart';

class HiveDatingProfile implements LocalDatingProfileSource {
  final Box _datingProfileHiveBox = Hive.box<DatingProfile?>(datingProfileBox);

  @override
  Future<OperationResult> cacheDatingProfileAndGetIt(
      DatingProfile profile) async {
    try {
      await _datingProfileHiveBox.put(datingProfileKey, profile);
      return OperationResult(data: profile);
    } catch (e) {
      print("============ $e ===========");
      return OperationResult(
          errorMessage: createDatingProfileErr, errorOccurred: true);
    }
  }

  @override
  Future<DatingProfile?> getCachedDatingProfile() async {
    try {
      DatingProfile? profile =
          await _datingProfileHiveBox.get(datingProfileKey) as DatingProfile?;
      return profile;
    } catch (e) {
      print("============ getCachedDatingProfile $e ===========");
      return null;
    }
  }

  @override
  Future<bool> clearDatingProfileCache() async {
    try {
      await _datingProfileHiveBox.delete(datingProfileKey);
      return true;
    } catch (e) {
      print("============ $e ===========");
      return false;
    }
  }

  @override
  Future<OperationResult> updateDatingProfileCacheAndGetIt(
      DatingProfile profile) async {
    try {
      bool isCleared = await clearDatingProfileCache();
      if (!isCleared) {
        return OperationResult(
            errorOccurred: true, errorMessage: updateDatingProfileErr);
      }

      return await cacheDatingProfileAndGetIt(profile);
    } catch (e) {
      print("============ $e ===========");
      return OperationResult(
          errorMessage: updateDatingProfileErr, errorOccurred: true);
    }
  }
}

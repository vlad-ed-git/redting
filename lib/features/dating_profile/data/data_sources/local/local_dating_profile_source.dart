import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';

abstract class LocalDatingProfileSource {
  Future<OperationResult> updateDatingProfileCacheAndGetIt(
      DatingProfile profile);
  Future<bool> clearDatingProfileCache();
  Future<OperationResult> cacheDatingProfileAndGetIt(DatingProfile profile);
  Future<DatingProfile?> getCachedDatingProfile();
}

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/domain/models/ice_breaker_msg.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

abstract class MatchingRepository {
  Future<ServiceResult> getThisUserInfo();
  Future<ServiceResult> getProfilesToMatchWith(UserProfile thisUserProfiles);
  Future<ServiceResult> likeUser(String thisUserId, String likedUserId,
      String likedUserName, String likedUserProfilePhotoUrl);
  Future<ServiceResult> sendDailyFeedback(
      String userId, String feedback, int rating);
  Stream<List<OperationRealTimeResult>> listenToMatches();

  /// initializations ---syncing ---
  Future<bool> loadLikedUsersToCache();
  Future<bool> loadIceBreakerMessagesToCache();
  Future<IceBreakerMessages?> getCachedIceBreakers();
}

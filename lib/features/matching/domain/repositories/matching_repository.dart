import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

abstract class MatchingRepository {
  Future<OperationResult> getThisUserInfo();
  Future<OperationResult> getProfilesToMatchWith(UserProfile thisUserProfiles);
  Future<OperationResult> likeUser(String thisUserId, String likedUserId,
      String likedUserName, String likedUserProfilePhotoUrl);
  Future<OperationResult> sendDailyFeedback(
      String userId, String feedback, int rating);
  Stream<List<OperationRealTimeResult>> listenToMatches();

  /// initializations ---syncing ---
  Future<bool> loadLikedUsersToCache();
  Future<bool> loadIceBreakerMessagesToCache();
}

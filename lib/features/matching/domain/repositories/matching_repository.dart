import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/domain/utils/matching_user_profile_wrapper.dart';

abstract class MatchingRepository {
  Future<OperationResult> getThisUserInfo();
  Future<OperationResult> getDatingProfiles(
      MatchingUserProfileWrapper thisUserProfiles);
  Future<OperationResult> likeUser(String thisUserId, String likedUserId,
      String likedUserName, String likedUserProfilePhotoUrl);
  Future<OperationResult> sendDailyFeedback(
      String userId, String feedback, int rating);
  Stream<List<OperationRealTimeResult>> listenToMatches();

  /// initializations ---syncing ---
  Future<bool> loadLikedUsersToCache();
  Future<bool> loadIceBreakerMessagesToCache();
}

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/domain/models/daily_user_feedback.dart';
import 'package:redting/features/matching/domain/models/ice_breaker_msg.dart';
import 'package:redting/features/matching/domain/models/liked_user.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

abstract class RemoteMatchingDataSource {
  Future<ServiceResult> likeUser(
      LikedUser likedUser, MatchingProfiles matchingProfiles);
  Future<IceBreakerMessages?> getIceBreakerMessages();
  Future<List<UserProfile>?> getProfilesToMatchWith(
    UserProfile thisUsersProfile,
  );
  Future<ServiceResult> sendDailyFeedback(DailyUserFeedback dailyUserFeedback);
  Stream<List<OperationRealTimeResult>> listenToMatches();
  Future<ServiceResult> getUsersILike();
}

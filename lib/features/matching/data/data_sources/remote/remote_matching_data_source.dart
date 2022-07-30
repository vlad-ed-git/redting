import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/matching/domain/models/daily_user_feedback.dart';
import 'package:redting/features/matching/domain/models/ice_breaker_msg.dart';
import 'package:redting/features/matching/domain/models/liked_user.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';
import 'package:redting/features/matching/domain/utils/matching_user_profile_wrapper.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

abstract class RemoteMatchingDataSource {
  Future<OperationResult> likeUser(
      LikedUser likedUser, MatchingProfiles matchingProfiles);
  Future<IceBreakerMessages?> getIceBreakerMessages();
  Future<List<MatchingUserProfileWrapper>?> getDatingProfiles(
      UserProfile thisUsersProfile, DatingProfile thisUsersDatingProfile);
  Future<OperationResult> sendDailyFeedback(
      DailyUserFeedback dailyUserFeedback);
  Stream<List<OperationRealTimeResult>> listenToMatches();
  Future<OperationResult> getUsersILike();
}

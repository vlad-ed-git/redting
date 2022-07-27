import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/matching/domain/models/daily_user_feedback.dart';
import 'package:redting/features/matching/domain/models/ice_breaker_msg.dart';
import 'package:redting/features/matching/domain/models/like_notification.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';
import 'package:redting/features/matching/domain/repositories/matching_user_profile_wrapper.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

abstract class RemoteMatchingDataSource {
  Future<OperationResult> likeUser(
      LikeNotification likeNotification, MatchingProfiles matchingProfiles);
  Future<IceBreakerMessages?> getIceBreakerMessages();
  Future<List<MatchingUserProfileWrapper>?> getDatingProfiles(
      UserProfile thisUsersProfile, DatingProfile thisUsersDatingProfile);
  Future<OperationResult> sendDailyFeedback(
      DailyUserFeedback dailyUserFeedback);
  Stream<List<OperationRealTimeResult>> listenToMatches();
}

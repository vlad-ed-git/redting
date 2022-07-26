import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/home/domain/repositories/matching_user_profile_wrapper.dart';

abstract class MatchingRepository {
  Future<OperationResult> getMatchingUserProfileWrapper();
  Future<OperationResult> getDatingProfiles(
      MatchingUserProfileWrapper thisUserProfiles);
  Future<OperationResult> likeUser(String thisUser, String likedUser);
  Future loadIceBreakerMessages();
  Future<OperationResult> sendDailyFeedback(
      String userId, String feedback, int rating);
}

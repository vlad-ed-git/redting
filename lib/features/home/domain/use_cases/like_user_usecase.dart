import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/home/domain/repositories/matching_repository.dart';
import 'package:redting/features/home/domain/repositories/matching_user_profile_wrapper.dart';

class LikeUserUseCase {
  final MatchingRepository repository;
  LikeUserUseCase(this.repository);

  Future<OperationResult> execute(
      MatchingUserProfileWrapper thisUserProfiles, String likedUserId) async {
    return await repository.likeUser(thisUserProfiles, likedUserId);
  }
}

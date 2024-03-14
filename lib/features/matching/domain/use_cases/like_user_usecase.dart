import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/domain/repositories/matching_repository.dart';

class LikeUserUseCase {
  final MatchingRepository repository;
  LikeUserUseCase(this.repository);

  Future<ServiceResult> execute(String thisUser, String likedUser,
      String likedUserName, String likedUserProfilePhotoUrl) async {
    return await repository.likeUser(
        thisUser, likedUser, likedUserName, likedUserProfilePhotoUrl);
  }
}

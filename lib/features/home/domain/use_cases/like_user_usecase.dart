import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/home/domain/repositories/matching_repository.dart';

class LikeUserUseCase {
  final MatchingRepository repository;
  LikeUserUseCase(this.repository);

  Future<OperationResult> execute(String thisUser, String likedUser) async {
    return await repository.likeUser(thisUser, likedUser);
  }
}

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/domain/repositories/matching_repository.dart';

class SendUserDailyFeedback {
  final MatchingRepository repository;
  SendUserDailyFeedback(this.repository);

  Future<OperationResult> execute(
      String userId, String feedback, int rating) async {
    return await repository.sendDailyFeedback(userId, feedback, rating);
  }
}

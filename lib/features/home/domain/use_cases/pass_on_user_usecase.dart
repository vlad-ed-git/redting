import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/home/domain/repositories/matching_repository.dart';

class PassOnUserUseCase {
  final MatchingRepository repository;
  PassOnUserUseCase(this.repository);

  Future<OperationResult> execute(String dislikedUserId) async {
    return OperationResult();

    ///TODO IMPLEMENT?
  }
}

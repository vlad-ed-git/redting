import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/domain/repositories/matching_repository.dart';

class PassOnUserUseCase {
  final MatchingRepository repository;
  PassOnUserUseCase(this.repository);

  Future<ServiceResult> execute(String dislikedUserId) async {
    return ServiceResult();

    ///TODO IMPLEMENT?
  }
}

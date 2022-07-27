import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/domain/repositories/matching_repository.dart';

class InitializeUseCase {
  final MatchingRepository repository;
  InitializeUseCase(this.repository);

  Future<OperationResult> execute() async {
    await repository.loadIceBreakerMessages();
    return await repository.getMatchingUserProfileWrapper();
  }
}

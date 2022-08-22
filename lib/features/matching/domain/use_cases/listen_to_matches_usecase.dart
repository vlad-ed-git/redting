import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/domain/repositories/matching_repository.dart';

class ListenToMatchUseCase {
  final MatchingRepository repository;
  ListenToMatchUseCase(this.repository);

  Stream<List<OperationRealTimeResult>> execute() =>
      repository.listenToMatches();
}

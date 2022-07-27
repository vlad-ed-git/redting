import 'package:redting/features/matching/domain/repositories/matching_repository.dart';

class ListenToMatchUseCase {
  final MatchingRepository repository;
  ListenToMatchUseCase(this.repository);

  execute() => repository.listenToMatches();
}

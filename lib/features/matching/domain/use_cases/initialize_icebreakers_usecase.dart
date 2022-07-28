import 'package:redting/features/matching/domain/repositories/matching_repository.dart';

class InitializeIceBreakersUseCase {
  final MatchingRepository repository;
  InitializeIceBreakersUseCase(this.repository);

  Future execute() async {
    await repository.loadIceBreakerMessages();
  }
}

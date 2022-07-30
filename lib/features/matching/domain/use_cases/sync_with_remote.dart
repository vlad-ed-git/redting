import 'package:redting/features/matching/domain/repositories/matching_repository.dart';

class SyncWithRemote {
  final MatchingRepository repository;
  SyncWithRemote(this.repository);

  Future execute() async {
    await repository.loadIceBreakerMessagesToCache();
    await repository.loadLikedUsersToCache();
  }
}

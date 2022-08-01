import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/domain/repositories/matching_repository.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

class FetchProfilesToMatch {
  final MatchingRepository repository;
  FetchProfilesToMatch(this.repository);

  Future<OperationResult> execute(UserProfile thisUserProfile) async {
    return await repository.getProfilesToMatchWith(thisUserProfile);
  }
}

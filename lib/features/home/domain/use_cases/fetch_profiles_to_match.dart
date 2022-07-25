import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/home/domain/repositories/matching_repository.dart';
import 'package:redting/features/home/domain/repositories/matching_user_profile_wrapper.dart';

class FetchProfilesToMatch {
  final MatchingRepository repository;
  FetchProfilesToMatch(this.repository);

  Future<OperationResult> execute(
      MatchingUserProfileWrapper thisUserProfiles) async {
    return await repository.getDatingProfiles(thisUserProfiles);
  }
}

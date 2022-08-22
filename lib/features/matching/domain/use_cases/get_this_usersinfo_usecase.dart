import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/domain/repositories/matching_repository.dart';

class GetThisUsersInfoUseCase {
  final MatchingRepository repository;
  GetThisUsersInfoUseCase(this.repository);

  Future<ServiceResult> execute() async {
    return await repository.getThisUserInfo();
  }
}

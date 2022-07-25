import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/domain/repository/dating_profile_repo.dart';

class GetDatingProfilesUseCase {
  final DatingProfileRepo _repository;

  GetDatingProfilesUseCase(
    this._repository,
  );

  Future<OperationResult> execute(String userId) async {
    return await _repository.getDatingProfileFromRemote(userId);
  }
}

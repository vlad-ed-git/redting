import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/domain/repository/dating_profile_repo.dart';

class GetDatingProfileUseCase {
  final DatingProfileRepo _repository;

  GetDatingProfileUseCase(
    this._repository,
  );

  Future<OperationResult> execute(String userId) async {
    return await _repository.getDatingProfile(userId);
  }
}

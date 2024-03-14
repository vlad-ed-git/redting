import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/blind_date_setup/domain/repository/blind_date_repo.dart';

class CheckIfCanSetupBlindDateUseCase {
  final BlindDateRepo _blindDateRepo;
  CheckIfCanSetupBlindDateUseCase(this._blindDateRepo);

  Future<ServiceResult> execute(AuthUser user) async {
    return await _blindDateRepo.canSetupBlindDate(user);
  }
}

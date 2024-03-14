import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/blind_date_setup/domain/repository/blind_date_repo.dart';

class SetupBlindDateUseCase {
  final BlindDateRepo _blindDateRepo;
  SetupBlindDateUseCase(this._blindDateRepo);

  Future<ServiceResult> execute(AuthUser authUser, String phoneNumber1,
      String phoneNumber2, String iceBreaker) async {
    return await _blindDateRepo.setupBlindDate(
        authUser, phoneNumber1, phoneNumber2, iceBreaker);
  }
}

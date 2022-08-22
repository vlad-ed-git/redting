import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/blind_date_setup/domain/repository/blind_date_repo.dart';

class GetAuthUserUseCase {
  final BlindDateRepo _blindDateRepo;
  GetAuthUserUseCase(this._blindDateRepo);

  Future<ServiceResult> execute() async {
    return await _blindDateRepo.getAuthUserUseCase();
  }
}

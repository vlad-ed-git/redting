import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/blind_date_setup/domain/repository/blind_date_repo.dart';

class GetBlindDatesStreamUseCase {
  final BlindDateRepo _blindDateRepo;
  GetBlindDatesStreamUseCase(this._blindDateRepo);

  Stream<List<OperationRealTimeResult>> execute(String userId) {
    return _blindDateRepo.listenToNewBlindDateSetups(userId);
  }
}

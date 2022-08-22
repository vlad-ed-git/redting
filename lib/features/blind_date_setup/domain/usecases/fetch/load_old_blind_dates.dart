import 'package:redting/features/blind_date_setup/domain/model/blind_date.dart';
import 'package:redting/features/blind_date_setup/domain/repository/blind_date_repo.dart';

class LoadOlderBlindDatesUseCase {
  final BlindDateRepo _blindDateRepo;
  LoadOlderBlindDatesUseCase(this._blindDateRepo);

  Future<List<BlindDate>> execute(String userId) {
    return _blindDateRepo.loadOldBlindDateSetups(userId);
  }
}

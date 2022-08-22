import 'package:redting/features/blind_date_setup/domain/repository/blind_date_repo.dart';
import 'package:redting/features/matching/domain/models/ice_breaker_msg.dart';

class GetIceBreakersUseCase {
  final BlindDateRepo _blindDateRepo;
  GetIceBreakersUseCase(this._blindDateRepo);

  Future<IceBreakerMessages?> execute() async {
    return await _blindDateRepo.fetchIceBreakerMessages();
  }
}

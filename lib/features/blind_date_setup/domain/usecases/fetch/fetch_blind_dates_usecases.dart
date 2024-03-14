import 'package:redting/features/blind_date_setup/domain/usecases/fetch/listen_to_blind_dates_stream.dart';
import 'package:redting/features/blind_date_setup/domain/usecases/fetch/load_old_blind_dates.dart';
import 'package:redting/features/blind_date_setup/domain/usecases/get_user.dart';

class FetchBlindDatesUseCases {
  final GetBlindDatesStreamUseCase getBlindDatesStreamUseCase;
  final LoadOlderBlindDatesUseCase loadOlderBlindDatesUseCase;
  final GetAuthUserUseCase getAuthUserUseCase;
  FetchBlindDatesUseCases(this.getBlindDatesStreamUseCase,
      this.loadOlderBlindDatesUseCase, this.getAuthUserUseCase);
}

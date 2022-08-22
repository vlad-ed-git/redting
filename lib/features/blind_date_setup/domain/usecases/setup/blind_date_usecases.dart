import 'package:redting/features/blind_date_setup/domain/usecases/get_user.dart';
import 'package:redting/features/blind_date_setup/domain/usecases/setup/check_if_can_setup_blind_date.dart';
import 'package:redting/features/blind_date_setup/domain/usecases/setup/get_icebreakers.dart';
import 'package:redting/features/blind_date_setup/domain/usecases/setup/setup_blind_date.dart';

class BlindDateUseCases {
  final CheckIfCanSetupBlindDateUseCase checkIfCanSetup;
  final GetAuthUserUseCase getAuthUser;
  final SetupBlindDateUseCase setupBlindDate;
  final GetIceBreakersUseCase getIceBreakersUseCase;
  BlindDateUseCases(this.checkIfCanSetup, this.getAuthUser, this.setupBlindDate,
      this.getIceBreakersUseCase);
}

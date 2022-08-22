import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/blind_date_setup/domain/usecases/setup/blind_date_usecases.dart';
import 'package:redting/features/matching/domain/models/ice_breaker_msg.dart';
import 'package:redting/res/strings.dart';

part 'blind_date_event.dart';
part 'blind_date_state.dart';

class BlindDateBloc extends Bloc<BlindDateEvent, BlindDateState> {
  final BlindDateUseCases _blindDateUseCases;
  BlindDateBloc(this._blindDateUseCases) : super(BlindDateInitial()) {
    on<GetAuthUserEvent>(_onGetAuthUserEvent);
    on<CheckIfCanSetupBlindDateEvent>(_onCheckIfCanSetupBlindDateEvent);
    on<SetupBlindDateEvent>(_onSetupBlindDateEvent);
    on<GettingIceBreakersEvent>(_onGettingIceBreakersEvent);
  }

  FutureOr<void> _onGetAuthUserEvent(
      GetAuthUserEvent event, Emitter<BlindDateState> emit) async {
    emit(GettingAuthUserState());
    ServiceResult result = await _blindDateUseCases.getAuthUser.execute();
    if (result.errorOccurred || result.data is! AuthUser) {
      emit(GettingAuthUserFailedState(
          result.errorMessage ?? blindDateSetupUnknownErr));
    } else {
      emit(GettingAuthUserSuccessfulState(result.data as AuthUser));
    }
  }

  FutureOr<void> _onCheckIfCanSetupBlindDateEvent(
      CheckIfCanSetupBlindDateEvent event, Emitter<BlindDateState> emit) async {
    emit(CheckingIfCanSetupBlindDateState());

    ServiceResult result =
        await _blindDateUseCases.checkIfCanSetup.execute(event.authUser);
    if (result.errorOccurred || result.data is! bool) {
      emit(CheckingIfCanSetupDateFailedState(
          result.errorMessage ?? blindDateSetupUnknownErr));
    } else {
      emit(CheckingIfCanSetupDateSuccessfulState(result.data as bool));
    }
  }

  FutureOr<void> _onSetupBlindDateEvent(
      SetupBlindDateEvent event, Emitter<BlindDateState> emit) async {
    emit(SettingUpBlindDateState());
    ServiceResult result = await _blindDateUseCases.setupBlindDate.execute(
        event.authUser,
        event.phoneNumber1,
        event.phoneNumber2,
        event.iceBreaker);
    if (result.errorOccurred) {
      emit(SettingUpBlindDateFailedState(
          result.errorMessage ?? blindDateSetupUnknownErr));
    } else {
      emit(SettingUpBlindDateSuccessfulState());
    }
  }

  FutureOr<void> _onGettingIceBreakersEvent(
      GettingIceBreakersEvent event, Emitter<BlindDateState> emit) async {
    emit(GettingIceBreakersState());
    IceBreakerMessages? iceBreakerMessages =
        await _blindDateUseCases.getIceBreakersUseCase.execute();

    if (iceBreakerMessages != null) {
      emit(GettingIceBreakersSuccessState(iceBreakerMessages));
    } else {
      emit(GettingIceBreakersFailedState());
    }
  }
}

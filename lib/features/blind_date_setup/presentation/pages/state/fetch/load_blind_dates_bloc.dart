import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/blind_date_setup/domain/model/blind_date.dart';
import 'package:redting/features/blind_date_setup/domain/usecases/fetch/fetch_blind_dates_usecases.dart';
import 'package:redting/res/strings.dart';

part 'load_blind_dates_event.dart';
part 'load_blind_dates_state.dart';

class LoadBlindDatesBloc
    extends Bloc<LoadBlindDatesEvent, LoadBlindDatesState> {
  final FetchBlindDatesUseCases _blindDatesUseCases;
  LoadBlindDatesBloc(this._blindDatesUseCases)
      : super(LoadBlindDatesInitial()) {
    on<GetAuthUserEvent>(_onGetAuthUserEvent);
    on<ListenToBlindDatesEvent>(_onListenToBlindDatesEvent);
    on<LoadMoreBlindDatesEvent>(_onLoadMoreBlindDatesEvent);
  }

  FutureOr<void> _onGetAuthUserEvent(
      GetAuthUserEvent event, Emitter<LoadBlindDatesState> emit) async {
    emit(GettingAuthUserState());
    ServiceResult result =
        await _blindDatesUseCases.getAuthUserUseCase.execute();
    if (result.errorOccurred || result.data is! AuthUser) {
      emit(GettingAuthUserFailedState(
          result.errorMessage ?? blindDateSetupUnknownErr));
    } else {
      emit(GettingAuthUserSuccessfulState(result.data as AuthUser));
    }
  }

  FutureOr<void> _onListenToBlindDatesEvent(
      ListenToBlindDatesEvent event, Emitter<LoadBlindDatesState> emit) {
    final stream =
        _blindDatesUseCases.getBlindDatesStreamUseCase.execute(event.userId);
    emit(ListeningToBlindDatesState(stream));
  }

  FutureOr<void> _onLoadMoreBlindDatesEvent(
      LoadMoreBlindDatesEvent event, Emitter<LoadBlindDatesState> emit) async {
    emit((LoadingState()));
    List<BlindDate> blindDates = await _blindDatesUseCases
        .loadOlderBlindDatesUseCase
        .execute(event.userId);
    emit(LoadedOlderBlindDatesState(blindDates));
  }
}

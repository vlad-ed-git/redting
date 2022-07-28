import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/domain/use_cases/matching_usecases.dart';
import 'package:redting/features/matching/domain/utils/matching_user_profile_wrapper.dart';
import 'package:redting/res/strings.dart';

part 'matches_listener_event.dart';
part 'matches_listener_state.dart';

class MatchesListenerBloc
    extends Bloc<MatchesListenerEvent, MatchesListenerState> {
  final MatchingUseCases matchingUseCases;
  MatchesListenerBloc(this.matchingUseCases)
      : super(MatchesListenerInitialState()) {
    on<ListenToMatchesEvent>(_onListenToMatchesEvent);
    on<LoadThisUserProfileEvent>(_onLoadThisUserProfileEvent);
  }

  FutureOr<void> _onListenToMatchesEvent(
      ListenToMatchesEvent event, Emitter<MatchesListenerState> emit) {
    var stream = matchingUseCases.listenToMatchUseCase.execute();
    emit(ListeningToMatchesState(stream));
  }

  FutureOr<void> _onLoadThisUserProfileEvent(LoadThisUserProfileEvent event,
      Emitter<MatchesListenerState> emit) async {
    OperationResult result =
        await matchingUseCases.getThisUsersInfoUseCase.execute();

    if (result.errorOccurred || result.data is! MatchingUserProfileWrapper) {
      emit(LoadingThisUserProfileFailedState(
          result.errorMessage ?? loadingAuthUserErr));
    } else {
      emit(LoadedThisUserProfileState(
          result.data as MatchingUserProfileWrapper));
    }
  }
}

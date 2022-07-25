import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/home/domain/repositories/matching_user_profile_wrapper.dart';
import 'package:redting/features/home/domain/use_cases/matching_usecases.dart';
import 'package:redting/res/strings.dart';

part 'matching_event.dart';
part 'matching_state.dart';

class MatchingBloc extends Bloc<MatchingEvent, MatchingState> {
  final MatchingUseCases matchingUseCases;
  MatchingBloc(this.matchingUseCases) : super(MatchingInitialState()) {
    on<InitializeEvent>(_onInitializeEvent);
    on<LoadProfilesEvent>(_onLoadProfilesEvent);
  }

  FutureOr<void> _onInitializeEvent(
      InitializeEvent event, Emitter<MatchingState> emit) async {
    emit(LoadingState());

    OperationResult result =
        await matchingUseCases.initializeUserProfilesUseCase.execute();
    if (result.errorOccurred || result.data is! MatchingUserProfileWrapper) {
      emit(InitializingMatchingFailedState(
          result.errorMessage ?? loadingAuthUserErr));
    }

    if (result.data is MatchingUserProfileWrapper) {
      emit(InitializedMatchingState(result.data));
    }
  }

  FutureOr<void> _onLoadProfilesEvent(
      LoadProfilesEvent event, Emitter<MatchingState> emit) async {
    emit(LoadingState());
    OperationResult result = await matchingUseCases.fetchProfilesToMatch
        .execute(event._userProfileWrapper);
    if (result.errorOccurred ||
        result.data is! List<MatchingUserProfileWrapper>) {
      emit(FetchingMatchesFailedState(
          result.errorMessage ?? fetchingProfilesToMatchFailed));
    } else {
      emit(FetchedProfilesToMatchState(
          result.data as List<MatchingUserProfileWrapper>));
    }
  }
}

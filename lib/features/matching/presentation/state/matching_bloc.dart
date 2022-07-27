import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/domain/repositories/matching_user_profile_wrapper.dart';
import 'package:redting/features/matching/domain/use_cases/matching_usecases.dart';
import 'package:redting/res/strings.dart';

part 'matching_event.dart';
part 'matching_state.dart';

class MatchingBloc extends Bloc<MatchingEvent, MatchingState> {
  final MatchingUseCases matchingUseCases;
  MatchingBloc(this.matchingUseCases) : super(MatchingInitialState()) {
    on<InitializeEvent>(_onInitializeEvent);
    on<LoadProfilesEvent>(_onLoadProfilesEvent);
    on<LikeUserEvent>(_onLikeUserEvent);
    on<SendUserFeedBackEvent>(_onSendUserFeedBackEvent);
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

  FutureOr<void> _onLikeUserEvent(
      LikeUserEvent event, Emitter<MatchingState> emit) async {
    emit(LikingUserState());
    OperationResult result = await matchingUseCases.likeUserUseCase.execute(
        event.likedByUser,
        event.likedUserProfile.userProfile.userId,
        event.likedUserProfile.userProfile.name,
        event.likedUserProfile.userProfile.profilePhotoUrl);
    if (result.errorOccurred) {
      emit(LikingUserFailedState(event.likedUserProfile));
    } else {
      emit(LikingUserSuccessState());
    }
  }

  FutureOr<void> _onSendUserFeedBackEvent(
      SendUserFeedBackEvent event, Emitter<MatchingState> emit) async {
    emit(SendingFeedbackState());
    OperationResult result = await matchingUseCases.sendUserDailyFeedback
        .execute(event.userId, event.feedback, event.rating);

    if (result.errorOccurred) {
      emit(SendingFeedbackFailedState());
    }

    if (!result.errorOccurred) {
      emit(SendingFeedbackSuccessState());
    }
  }
}

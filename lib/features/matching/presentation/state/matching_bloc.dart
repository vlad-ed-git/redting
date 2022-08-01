import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/domain/use_cases/matching_usecases.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/res/strings.dart';

part 'matching_event.dart';
part 'matching_state.dart';

class MatchingBloc extends Bloc<MatchingEvent, MatchingState> {
  final MatchingUseCases matchingUseCases;
  MatchingBloc(this.matchingUseCases) : super(MatchingInitialState()) {
    on<InitializeEvent>(_onInitializeEvent);
    on<LoadProfilesToMatchEvent>(_onLoadProfilesEvent);
    on<LikeUserEvent>(_onLikeUserEvent);
    on<SendUserFeedBackEvent>(_onSendUserFeedBackEvent);
  }

  FutureOr<void> _onInitializeEvent(
      InitializeEvent event, Emitter<MatchingState> emit) async {
    emit(LoadingState());

    await matchingUseCases.syncWithRemote.execute();
    OperationResult result =
        await matchingUseCases.getThisUsersInfoUseCase.execute();
    if (result.errorOccurred || result.data is! UserProfile) {
      emit(InitializingMatchingFailedState(
          result.errorMessage ?? loadingAuthUserErr));
    }

    if (result.data is UserProfile) {
      emit(InitializedMatchingState(result.data as UserProfile));
    }
  }

  FutureOr<void> _onLoadProfilesEvent(
      LoadProfilesToMatchEvent event, Emitter<MatchingState> emit) async {
    emit(LoadingState());
    OperationResult result =
        await matchingUseCases.fetchProfilesToMatch.execute(event.profiles);
    if (result.errorOccurred || result.data is! List<UserProfile>) {
      emit(FetchingMatchesFailedState(
          result.errorMessage ?? fetchingProfilesToMatchFailed));
    } else {
      emit(FetchedProfilesToMatchState(result.data as List<UserProfile>));
    }
  }

  FutureOr<void> _onLikeUserEvent(
      LikeUserEvent event, Emitter<MatchingState> emit) async {
    emit(LikingUserState());
    OperationResult result = await matchingUseCases.likeUserUseCase.execute(
        event.likedByUser,
        event.likedUserProfile.userId,
        event.likedUserProfile.name,
        event.likedUserProfile.profilePhotoUrl);
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

part of 'matching_bloc.dart';

@immutable
abstract class MatchingState {}

class MatchingInitialState extends MatchingState {}

class LoadingState extends MatchingState {}

class InitializedMatchingState extends MatchingState {
  final MatchingUserProfileWrapper wrapper;
  InitializedMatchingState(this.wrapper);
}

class InitializingMatchingFailedState extends MatchingState {
  final String errMsg;
  InitializingMatchingFailedState(this.errMsg);
}

class FetchedProfilesToMatchState extends MatchingState {
  final List<MatchingUserProfileWrapper> matchingProfiles;
  FetchedProfilesToMatchState(this.matchingProfiles);
}

class FetchingMatchesFailedState extends MatchingState {
  final String errMsg;
  FetchingMatchesFailedState(this.errMsg);
}

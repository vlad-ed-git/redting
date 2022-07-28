part of 'matches_listener_bloc.dart';

@immutable
abstract class MatchesListenerState {}

class MatchesListenerInitialState extends MatchesListenerState {}

class ListeningToMatchesState extends MatchesListenerState {
  final Stream<List<OperationRealTimeResult>> stream;
  ListeningToMatchesState(this.stream);
}

class LoadedThisUserProfileState extends MatchesListenerState {
  final MatchingUserProfileWrapper thisUserProfiles;
  LoadedThisUserProfileState(this.thisUserProfiles);
}

class LoadingThisUserProfileFailedState extends MatchesListenerState {
  final String errMsg;
  LoadingThisUserProfileFailedState(this.errMsg);
}

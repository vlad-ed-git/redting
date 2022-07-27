part of 'matches_listener_bloc.dart';

@immutable
abstract class MatchesListenerState {}

class MatchesListenerInitialState extends MatchesListenerState {}

class ListeningToMatchesState extends MatchesListenerState {
  final Stream<List<OperationRealTimeResult>> stream;
  ListeningToMatchesState(this.stream);
}

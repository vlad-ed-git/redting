part of 'matches_listener_bloc.dart';

@immutable
abstract class MatchesListenerEvent {}

class ListenToMatchesEvent extends MatchesListenerEvent {}

class LoadThisUserProfileEvent extends MatchesListenerEvent {}

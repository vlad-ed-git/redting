part of 'matching_bloc.dart';

@immutable
abstract class MatchingEvent {}

class InitializeEvent extends MatchingEvent {}

class LoadProfilesEvent extends MatchingEvent {
  final MatchingUserProfileWrapper _userProfileWrapper;
  LoadProfilesEvent(this._userProfileWrapper);
}

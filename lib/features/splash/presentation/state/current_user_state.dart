part of 'current_user_bloc.dart';

@immutable
abstract class CurrentUserState {}

class InitialState extends CurrentUserState {}

class LoadingCurrentUserState extends CurrentUserState {}

class LoadedCurrentUserState extends CurrentUserState {
  final AuthUser? authUser;
  final UserProfile? userProfile;
  LoadedCurrentUserState(this.authUser, this.userProfile);
}

class ErrorLoadingCurrentUserState extends CurrentUserState {
  final String errMsg;
  ErrorLoadingCurrentUserState(this.errMsg);
}

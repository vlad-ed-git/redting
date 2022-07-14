part of 'auth_user_bloc.dart';

@immutable
abstract class AuthUserState {}

class InitialAuthUserState extends AuthUserState {}

class LoadingAuthUserState extends AuthUserState {}

class LoadedAuthUserState extends AuthUserState {
  final AuthUser authUser;
  LoadedAuthUserState(this.authUser);
}

class ErrorLoadingAuthUserState extends AuthUserState {}

class NoAuthUserFoundState extends AuthUserState {}

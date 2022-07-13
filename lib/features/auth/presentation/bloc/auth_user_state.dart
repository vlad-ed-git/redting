part of 'auth_user_bloc.dart';

@immutable
abstract class AuthUserState {}

class InitialState extends AuthUserState {}

class LoadingAuthUser extends AuthUserState {}

class FoundAuthUser extends AuthUserState {
  final AuthUser authUser;
  FoundAuthUser(this.authUser);
}

class NoAuthUser extends AuthUserState {}

class ErrorGettingAuthUser extends AuthUserState {}

part of 'auth_user_bloc.dart';

@immutable
abstract class AuthUserState {}

class InitialAuthUserState extends AuthUserState {}

class LoadingAuthState extends AuthUserState {}

class ErrorLoadingAuthUserState extends AuthUserState {}

class NoAuthUserFoundState extends AuthUserState {}

/// verification
class CodeSentToPhoneState extends AuthUserState {
  final int? resendToken;
  final String verificationId;
  CodeSentToPhoneState({this.resendToken, required this.verificationId});
}

class VerificationFailedState extends AuthUserState {
  final String errMsg;
  VerificationFailedState(this.errMsg);
}

/// sign in
class SigningUserInFailedState extends AuthUserState {
  final String errMsg;
  SigningUserInFailedState(this.errMsg);
}

class UserSignedInState extends AuthUserState {
  final AuthUser authUser;
  UserSignedInState(this.authUser);
}

/// login steps / mode
class GetPhoneState extends AuthUserState {}

class GetCodeState extends AuthUserState {}

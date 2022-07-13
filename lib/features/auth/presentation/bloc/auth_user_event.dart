part of 'auth_user_bloc.dart';

@immutable
abstract class AuthUserEvent {}

class GetAuthUser implements AuthUserEvent {}

class AuthenticatePhoneNumber implements AuthUserEvent {
  final String phoneNumber; //in edit text field
  AuthenticatePhoneNumber(this.phoneNumber);
}

class VerifyPhoneNumber implements AuthUserEvent {
  final String phoneNumber;
  final String verificationCode;
  VerifyPhoneNumber(this.phoneNumber, this.verificationCode);
}

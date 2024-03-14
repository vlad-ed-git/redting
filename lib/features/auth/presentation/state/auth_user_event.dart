part of 'auth_user_bloc.dart';

@immutable
abstract class AuthUserEvent {}

class LoadAuthUserEvent extends AuthUserEvent {}

class VerifyAuthUserEvent extends AuthUserEvent {
  final String phoneNumber;
  final String countryCode;
  final int? resendToken;
  VerifyAuthUserEvent(
      {required this.phoneNumber, required this.countryCode, this.resendToken});
}

class SendVerificationCodeAttemptedEvent extends AuthUserEvent {
  final PhoneVerificationResult result;
  SendVerificationCodeAttemptedEvent(this.result);
}

class SignInAuthUserEvent extends AuthUserEvent {
  final String verificationId;
  final String smsCode;
  SignInAuthUserEvent({required this.verificationId, required this.smsCode});
}

/// login steps / mode
class SwitchLoginModeEvent extends AuthUserEvent {
  final bool isInGetPhoneNotGetCodeMode;
  SwitchLoginModeEvent({required this.isInGetPhoneNotGetCodeMode});
}

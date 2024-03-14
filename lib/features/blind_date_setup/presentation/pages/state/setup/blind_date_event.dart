part of 'blind_date_bloc.dart';

@immutable
abstract class BlindDateEvent {}

class GetAuthUserEvent extends BlindDateEvent {}

class CheckIfCanSetupBlindDateEvent extends BlindDateEvent {
  final AuthUser authUser;
  CheckIfCanSetupBlindDateEvent(this.authUser);
}

class SetupBlindDateEvent extends BlindDateEvent {
  final AuthUser authUser;
  final String phoneNumber1;
  final String phoneNumber2;
  final String iceBreaker;
  SetupBlindDateEvent(
      this.authUser, this.phoneNumber1, this.phoneNumber2, this.iceBreaker);
}

class GettingIceBreakersEvent extends BlindDateEvent {}

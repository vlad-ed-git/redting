part of 'blind_date_bloc.dart';

@immutable
abstract class BlindDateState {}

class BlindDateInitial extends BlindDateState {}

/// AUTH USER
class GettingAuthUserState extends BlindDateState {}

class GettingAuthUserFailedState extends BlindDateState {
  final String errMsg;
  GettingAuthUserFailedState(this.errMsg);
}

class GettingAuthUserSuccessfulState extends BlindDateState {
  final AuthUser user;
  GettingAuthUserSuccessfulState(this.user);
}

class CheckingIfCanSetupBlindDateState extends BlindDateState {}

class SettingUpBlindDateState extends BlindDateState {}

class CheckingIfCanSetupDateFailedState extends BlindDateState {
  final String errMsg;
  CheckingIfCanSetupDateFailedState(this.errMsg);
}

class SettingUpBlindDateFailedState extends BlindDateState {
  final String errMsg;
  SettingUpBlindDateFailedState(this.errMsg);
}

class CheckingIfCanSetupDateSuccessfulState extends BlindDateState {
  final bool canSetup;
  CheckingIfCanSetupDateSuccessfulState(this.canSetup);
}

class SettingUpBlindDateSuccessfulState extends BlindDateState {}

class GettingIceBreakersState extends BlindDateState {}

class GettingIceBreakersFailedState extends BlindDateState {}

class GettingIceBreakersSuccessState extends BlindDateState {
  final IceBreakerMessages iceBreakerMessages;
  GettingIceBreakersSuccessState(this.iceBreakerMessages);
}

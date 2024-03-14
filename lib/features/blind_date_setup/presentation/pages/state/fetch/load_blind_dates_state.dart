part of 'load_blind_dates_bloc.dart';

@immutable
abstract class LoadBlindDatesState {}

class LoadBlindDatesInitial extends LoadBlindDatesState {}

class LoadingState extends LoadBlindDatesState {}

class GettingAuthUserState extends LoadBlindDatesState {}

class GettingAuthUserFailedState extends LoadBlindDatesState {
  final String errMsg;
  GettingAuthUserFailedState(this.errMsg);
}

class GettingAuthUserSuccessfulState extends LoadBlindDatesState {
  final AuthUser user;
  GettingAuthUserSuccessfulState(this.user);
}

class ChatLoadingState extends LoadBlindDatesState {}

class ListeningToBlindDatesState extends LoadBlindDatesState {
  final Stream<List<OperationRealTimeResult>> stream;
  ListeningToBlindDatesState(this.stream);
}

class LoadedOlderBlindDatesState extends LoadBlindDatesState {
  final List<BlindDate> dates;
  LoadedOlderBlindDatesState(this.dates);
}

part of 'load_blind_dates_bloc.dart';

@immutable
abstract class LoadBlindDatesEvent {}

class GetAuthUserEvent extends LoadBlindDatesEvent {}

class ListenToBlindDatesEvent extends LoadBlindDatesEvent {
  final String userId;
  ListenToBlindDatesEvent({
    required this.userId,
  });
}

class LoadMoreBlindDatesEvent extends LoadBlindDatesEvent {
  final String userId;
  LoadMoreBlindDatesEvent({
    required this.userId,
  });
}

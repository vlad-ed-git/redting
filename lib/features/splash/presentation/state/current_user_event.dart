part of 'current_user_bloc.dart';

@immutable
abstract class CurrentUserEvent {}

class LoadCurrentUserEvent extends CurrentUserEvent {}

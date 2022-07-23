part of 'dating_profile_bloc.dart';

@immutable
abstract class DatingProfileEvent {}

class LoadDatingProfileEvent extends DatingProfileEvent {
  final String userId;
  LoadDatingProfileEvent(this.userId);
}

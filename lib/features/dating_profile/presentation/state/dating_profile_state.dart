part of 'dating_profile_bloc.dart';

@immutable
abstract class DatingProfileState {}

class DatingProfileInitialState extends DatingProfileState {}

class LoadingDatingProfileState extends DatingProfileState {}

class LoadedDatingProfileState extends DatingProfileState {
  final DatingProfile profile;
  LoadedDatingProfileState(this.profile);
}

class NoDatingProfileState extends DatingProfileState {}

class LoadingDatingProfileFailedState extends DatingProfileState {
  final String errMsg;
  LoadingDatingProfileFailedState(this.errMsg);
}

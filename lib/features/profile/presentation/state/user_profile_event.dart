part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileEvent {}

class LoadUserProfileEvent extends UserProfileEvent {}

/// verification profile
class ChangeProfilePhotoEvent extends UserProfileEvent {
  final File photoFile;
  ChangeProfilePhotoEvent(this.photoFile);
}

/// verification video
class ChangeVerificationVideoEvent extends UserProfileEvent {
  final File videoFile;
  ChangeVerificationVideoEvent(this.videoFile);
}

class GetVerificationVideoCodeEvent extends UserProfileEvent {}

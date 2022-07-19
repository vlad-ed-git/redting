part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileEvent {}

class LoadUserProfileEvent extends UserProfileEvent {}

/// verification profile
class ChangeProfilePhotoEvent extends UserProfileEvent {
  final File photoFile;
  final String filename;
  ChangeProfilePhotoEvent(this.photoFile, this.filename);
}

/// verification video
class ChangeVerificationVideoEvent extends UserProfileEvent {
  final File videoFile;
  ChangeVerificationVideoEvent(this.videoFile);
}

class GetVerificationVideoCodeEvent extends UserProfileEvent {}

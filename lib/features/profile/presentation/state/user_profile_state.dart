part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileState {}

class UserProfileInitialState extends UserProfileState {}

class LoadingUserProfileState extends UserProfileState {}

class LoadedUserProfileState extends UserProfileState {
  final UserProfile profile;
  LoadedUserProfileState({required this.profile});
}

class ErrorLoadingUserProfileState extends UserProfileState {
  final String? errMsg;
  ErrorLoadingUserProfileState({required this.errMsg});
}

class NoAuthUserFoundState extends UserProfileState {}

/// PROFILE PHOTO
class UpdatingProfilePhotoState extends UserProfileState {
  final File photoBeingUploaded;
  UpdatingProfilePhotoState(this.photoBeingUploaded);
}

class UpdatedProfilePhotoState extends UserProfileState {
  final String photoUrl;
  UpdatedProfilePhotoState(this.photoUrl);
}

class UpdatingProfilePhotoFailedState extends UserProfileState {
  final String errMsg;
  UpdatingProfilePhotoFailedState(this.errMsg);
}

/// VERIFICATION VIDEO
class UpdatingVerificationVideoState extends UserProfileState {
  final File videoBeingUploaded;
  UpdatingVerificationVideoState(this.videoBeingUploaded);
}

class UpdatedVerificationVideoState extends UserProfileState {
  final String videoUrl;
  UpdatedVerificationVideoState(this.videoUrl);
}

class UpdatingVerificationVideoFailedState extends UserProfileState {
  final String errMsg;
  UpdatingVerificationVideoFailedState(this.errMsg);
}

class LoadingVerificationVideoCodeState extends UserProfileState {}

class LoadedVerificationVideoCodeState extends UserProfileState {
  final String verificationVideoCode;
  LoadedVerificationVideoCodeState(this.verificationVideoCode);
}
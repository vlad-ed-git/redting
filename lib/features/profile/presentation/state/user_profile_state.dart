part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileState {}

class UserProfileInitialState extends UserProfileState {}

/// USER PROFILE GET
class LoadingUserProfileState extends UserProfileState {}

class LoadedUserProfileState extends UserProfileState {
  final UserProfile profile;
  LoadedUserProfileState({required this.profile});
}

class ErrorLoadingUserProfileState extends UserProfileState {
  final String errMsg;
  ErrorLoadingUserProfileState({required this.errMsg});
}

class NoAuthUserFoundState extends UserProfileState {}

/// USER PROFILE CREATING
class CreatingUserProfileState extends UserProfileState {}

class CreatedUserProfileState extends UserProfileState {
  final UserProfile profile;
  CreatedUserProfileState({required this.profile});
}

class ErrorCreatingUserProfileState extends UserProfileState {
  final String? errMsg;
  ErrorCreatingUserProfileState({required this.errMsg});
}

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
  final UserVerificationVideo userVerificationVideo;
  UpdatedVerificationVideoState(this.userVerificationVideo);
}

class UpdatingVerificationVideoFailedState extends UserProfileState {
  final String errMsg;
  UpdatingVerificationVideoFailedState(this.errMsg);
}

//deleting the video
class DeletingVerificationVideoState extends UserProfileState {}

class DeletingVerificationVideoFailedState extends UserProfileState {
  final String errMsg;
  DeletingVerificationVideoFailedState(this.errMsg);
}

class DeletedVerificationVideoState extends UserProfileState {}

/// VERIFICATION CODE
class LoadingVerificationVideoCodeState extends UserProfileState {}

class LoadingVerificationVideoCodeFailedState extends UserProfileState {
  final String errMsg;
  LoadingVerificationVideoCodeFailedState(this.errMsg);
}

class LoadedVerificationVideoCodeState extends UserProfileState {
  final String verificationVideoCode;
  LoadedVerificationVideoCodeState(this.verificationVideoCode);
}

/// DATING INFO
class SettingDatingInfoState extends UserProfileState {}

class SettingDatingInfoFailedState extends UserProfileState {
  final String errMsg;
  SettingDatingInfoFailedState(this.errMsg);
}

class SetDatingInfoState extends UserProfileState {
  final UserProfile profile;
  SetDatingInfoState(this.profile);
}

/// USER PROFILE UPDATING
class UpdatingUserProfileState extends UserProfileState {}

class UpdatedUserProfileState extends UserProfileState {
  final UserProfile newProfile;
  UpdatedUserProfileState(this.newProfile);
}

class ErrorUpdatingUserProfileState extends UserProfileState {
  final String errMsg;
  ErrorUpdatingUserProfileState(this.errMsg);
}

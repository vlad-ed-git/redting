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
  final String verificationCode;
  ChangeVerificationVideoEvent(this.videoFile, this.verificationCode);
}

class DeleteVerificationVideoEvent extends UserProfileEvent {}

class GetVerificationVideoCodeEvent extends UserProfileEvent {}

//creating user profile
class CreateUserProfileEvent extends UserProfileEvent {
  final String name;
  final String userId;
  final String phoneNumber;
  final String profilePhotoUrl;
  final String? genderOther;
  final UserGender gender;
  final String bio;
  final String title;
  final DateTime? birthDay;
  final String registerCountry;
  final UserVerificationVideo? verificationVideo;

  CreateUserProfileEvent({
    required this.registerCountry,
    required this.name,
    required this.userId,
    required this.phoneNumber,
    required this.profilePhotoUrl,
    required this.genderOther,
    required this.gender,
    required this.bio,
    required this.title,
    required this.birthDay,
    required this.verificationVideo,
  });
}

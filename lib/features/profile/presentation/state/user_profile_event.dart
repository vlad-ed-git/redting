part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileEvent {}

/// when a user might have a profile for instance new phone install but already registered
class LoadUserProfileFromRemoteEvent extends UserProfileEvent {}

// when a user profile should exist in cache e.g. view profile screen
class LoadCachedProfileEvent extends UserProfileEvent {}

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
    required this.profilePhotoUrl,
    required this.genderOther,
    required this.gender,
    required this.bio,
    required this.title,
    required this.birthDay,
    required this.verificationVideo,
  });
}

//adding dating info
class AddDatingInfoEvent extends UserProfileEvent {
  final UserProfile profile;
  final List<File> photoFiles;
  final int minAgePreference;
  final int maxAgePreference;
  final UserGender? genderPreference;
  final List<SexualOrientation> userOrientation;
  final bool makeMyOrientationPublic;
  final bool onlyShowMeOthersOfSameOrientation;
  final List<String> datingPicsFileNames;
  AddDatingInfoEvent(
      this.profile,
      this.photoFiles,
      this.minAgePreference,
      this.maxAgePreference,
      this.genderPreference,
      this.userOrientation,
      this.makeMyOrientationPublic,
      this.onlyShowMeOthersOfSameOrientation,
      this.datingPicsFileNames);
}

part of 'dating_profile_bloc.dart';

@immutable
abstract class DatingProfileEvent {}

class LoadDatingProfileEvent extends DatingProfileEvent {
  final String userId;
  LoadDatingProfileEvent(this.userId);
}

class CreateProfileEvent extends DatingProfileEvent {
  final String userId;
  final List<File> photoFiles;
  final int minAgePreference;
  final int maxAgePreference;
  final UserGender? genderPreference;
  final List<SexualOrientation> userOrientation;
  final bool makeMyOrientationPublic;
  final bool onlyShowMeOthersOfSameOrientation;
  final List<String> datingPicsFileNames;
  CreateProfileEvent(
      this.userId,
      this.photoFiles,
      this.minAgePreference,
      this.maxAgePreference,
      this.genderPreference,
      this.userOrientation,
      this.makeMyOrientationPublic,
      this.onlyShowMeOthersOfSameOrientation,
      this.datingPicsFileNames);
}

import 'dart:io';

import 'package:redting/core/utils/consts.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/data/data_sources/local/local_profile_source.dart';
import 'package:redting/features/profile/data/data_sources/remote/remote_profile_source.dart';
import 'package:redting/features/profile/data/entities/user_gender_entity.dart';
import 'package:redting/features/profile/data/entities/user_profile_entity.dart';
import 'package:redting/features/profile/data/entities/user_verification_video_entity.dart';
import 'package:redting/features/profile/data/utils/compressors/image_compressor.dart';
import 'package:redting/features/profile/data/utils/compressors/video_compressor.dart';
import 'package:redting/features/profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';
import 'package:redting/features/profile/domain/repositories/profile_repository.dart';
import 'package:redting/features/profile/domain/utils/dating_pic.dart';
import 'package:redting/res/strings.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final RemoteProfileDataSource remoteProfileDataSource;
  final LocalProfileDataSource localProfileDataSource;
  final VideoCompressor videoCompressor;
  final ImageCompressor imageCompressor;

  ProfileRepositoryImpl(
      {required this.remoteProfileDataSource,
      required this.localProfileDataSource,
      required this.videoCompressor,
      required this.imageCompressor});

  @override
  Future<ServiceResult> createUserProfile(
      {required String name,
      required String userId,
      required String profilePhotoUrl,
      String? genderOther,
      required UserGender gender,
      required String bio,
      required String title,
      required DateTime? birthDay,
      required String registerCountry,
      required UserVerificationVideo? verificationVideo}) async {
    //check the data

    if (name.isEmpty) {
      return ServiceResult(errorOccurred: true, errorMessage: nameMissingErr);
    }
    if (userId.isEmpty) {
      return ServiceResult(
          errorOccurred: true,
          errorMessage: userIdMissingDuringProfileCreateErr);
    }
    if (profilePhotoUrl.isEmpty) {
      return ServiceResult(
          errorOccurred: true, errorMessage: emptyProfilePhotoErr);
    }
    if (verificationVideo == null) {
      return ServiceResult(
          errorOccurred: true, errorMessage: noVerificationVideo);
    }

    if (!UserProfile.isValidGender(gender: gender, genderOther: genderOther)) {
      return ServiceResult(
          errorOccurred: true, errorMessage: noGenderSpecified);
    }
    if ((bio.isEmpty || bio.length < UserProfile.userBioMinLen)) {
      return ServiceResult(errorOccurred: true, errorMessage: bioIsEmptyErr);
    }
    if (title.isEmpty || title.length < UserProfile.userTitleMinLen) {
      return ServiceResult(errorOccurred: true, errorMessage: titleIsEmptyErr);
    }
    if (title.length > UserProfile.userTitleMaxLen) {
      return ServiceResult(
          errorOccurred: true, errorMessage: titleIsTooLongErr);
    }
    if (!UserProfile.isOfLegalAge(birthDay: birthDay)) {
      return ServiceResult(errorOccurred: true, errorMessage: bDayNotSet);
    }

    UserProfile profile = _createNewUserProfileInstance(
        name: name,
        userId: userId,
        profilePhotoUrl: profilePhotoUrl,
        gender: gender,
        genderOther: genderOther,
        bio: bio,
        registerCountry: registerCountry,
        title: title,
        birthDay: birthDay!,
        isBanned: false,
        verificationVideo: verificationVideo);

    //remote
    UserProfile? savedProfile =
        await remoteProfileDataSource.createUserProfile(profile: profile);
    if (savedProfile == null) {
      return ServiceResult(
          errorOccurred: true, errorMessage: createProfileError);
    }

    return await _cacheUserProfileAndReturn(savedProfile);
  }

  Future<ServiceResult> _cacheUserProfileAndReturn(UserProfile profile) async {
    UserProfile? cachedProfile = await localProfileDataSource
        .cacheAndReturnUserProfile(profile: profile);
    return ServiceResult(
        errorOccurred: (cachedProfile == null),
        errorMessage: (cachedProfile == null) ? createProfileError : '',
        data: cachedProfile);
  }

  @override
  Future<ServiceResult> loadUserProfileFromRemoteIfExists() async {
    //remote
    final UserProfile? profile = await remoteProfileDataSource.getUserProfile();

    if (profile == null) return ServiceResult(); //does not exist

    //update cache
    return _cacheUserProfileAndReturn(profile);
  }

  @override
  Future<ServiceResult> uploadProfilePhoto(
      {required File file, required String filename}) async {
    String? downloadUrl = await remoteProfileDataSource.uploadProfilePhoto(
        file: file, filename: filename, imageCompressor: imageCompressor);
    return ServiceResult(errorOccurred: downloadUrl == null, data: downloadUrl);
  }

  @override
  Future<ServiceResult> generateVerificationWord() async {
    String? verificationWord =
        await remoteProfileDataSource.generateVerificationWord();
    return ServiceResult(
        errorOccurred: verificationWord == null, data: verificationWord);
  }

  @override
  Future<ServiceResult> uploadVerificationVideo(
      {required File file, required String verificationCode}) async {
    UserVerificationVideo? video =
        await remoteProfileDataSource.compressAndUploadVerificationVideo(
            file: file,
            verificationCode: verificationCode,
            compressor: videoCompressor);
    return ServiceResult(errorOccurred: video == null, data: video);
  }

  @override
  Future<ServiceResult> deleteVerificationVideo() async {
    bool isSuccess = await remoteProfileDataSource.deleteVerificationVideo();
    return ServiceResult(errorOccurred: !isSuccess);
  }

  @override
  Future<UserProfile?> getCachedUserProfile() {
    return localProfileDataSource.getCachedUserProfile();
  }

  @override
  Future<ServiceResult> addDatingPhoto(
      File photo, String filename, String userId) async {
    String? downloadUrl = await remoteProfileDataSource.uploadDatingPhoto(
        photo, filename, userId, imageCompressor);
    return downloadUrl != null
        ? ServiceResult(data: downloadUrl)
        : ServiceResult(
            errorOccurred: true, errorMessage: uploadingDatingProfilePhotoErr);
  }

  /// DATING PROFILE
  @override
  Future<ServiceResult> setDatingInfo(
      UserProfile profile,
      List<DatingPic> datingPics,
      int minAgePreference,
      int maxAgePreference,
      UserGender? genderPreference,
      List<SexualOrientation> userOrientation,
      bool makeMyOrientationPublic,
      bool onlyShowMeOthersOfSameOrientation) async {
    if (datingPics.length < minDatingProfilePhotosRequired) {
      return ServiceResult(
          errorOccurred: true, errorMessage: datingProfilePicsMissingErr);
    }

    //upload the files
    List<String> newDatingPicsUrls = [];
    for (DatingPic dPic in datingPics) {
      if (dPic.file != null) {
        //there is a file to upload
        File file = dPic.file!;
        String name = dPic.fileName ?? "${DateTime.now()}.jpeg";
        ServiceResult result = await addDatingPhoto(file, name, profile.userId);
        if (result.data is String) {
          newDatingPicsUrls.add(result.data);
        }
      } else {
        if (dPic.photoUrl != null) {
          newDatingPicsUrls.add(dPic.photoUrl!);
        }
      }
    }

    if (userOrientation.isEmpty) {
      //default orientation
      userOrientation.add(SexualOrientation.straight);
    }

    profile.datingPhotos = newDatingPicsUrls;
    profile.makeMyOrientationPublic = makeMyOrientationPublic;
    profile.onlyShowMeOthersOfSameOrientation =
        onlyShowMeOthersOfSameOrientation;
    profile.minAgePreference = minAgePreference;
    profile.maxAgePreference = maxAgePreference;
    profile.setGenderPreferences(genderPreference);
    profile.setUserSexualOrientation(userOrientation);

    UserProfile? updatedProfile =
        await remoteProfileDataSource.updateUserProfile(profile: profile);
    if (updatedProfile == null) {
      return ServiceResult(errorOccurred: true, errorMessage: setDatingInfoErr);
    }
    return _cacheUserProfileAndReturn(updatedProfile);
  }

  @override
  Future<ServiceResult> updateUserProfile({
    required UserProfile profile,
    required String name,
    required String profilePhotoUrl,
    required String? genderOther,
    required UserGender gender,
    required String bio,
    required String title,
    required DateTime birthDay,
    required String registerCountry,
  }) async {
    if (name.isEmpty) {
      return ServiceResult(errorOccurred: true, errorMessage: nameMissingErr);
    }
    if (profilePhotoUrl.isEmpty) {
      return ServiceResult(
          errorOccurred: true, errorMessage: emptyProfilePhotoErr);
    }

    if (!UserProfile.isValidGender(gender: gender, genderOther: genderOther)) {
      return ServiceResult(
          errorOccurred: true, errorMessage: noGenderSpecified);
    }
    if ((bio.isEmpty || bio.length < UserProfile.userBioMinLen)) {
      return ServiceResult(errorOccurred: true, errorMessage: bioIsEmptyErr);
    }
    if (title.isEmpty || title.length < UserProfile.userTitleMinLen) {
      return ServiceResult(errorOccurred: true, errorMessage: titleIsEmptyErr);
    }
    if (title.length > UserProfile.userTitleMaxLen) {
      return ServiceResult(
          errorOccurred: true, errorMessage: titleIsTooLongErr);
    }
    if (!UserProfile.isOfLegalAge(birthDay: birthDay)) {
      return ServiceResult(errorOccurred: true, errorMessage: bDayNotSet);
    }

    UserProfile updatedProfile = _createUpdatedProfileInstance(
        oldProfile: profile,
        name: name,
        profilePhotoUrl: profilePhotoUrl,
        genderOther: genderOther,
        gender: gender,
        bio: bio,
        title: title,
        birthDay: birthDay,
        registerCountry: registerCountry);
    //remote
    UserProfile? newProfile = await remoteProfileDataSource.updateUserProfile(
        profile: updatedProfile);
    if (newProfile == null) {
      return ServiceResult(
          errorOccurred: true, errorMessage: updateProfileError);
    }
    return await _cacheUserProfileAndReturn(newProfile);
  }

  /// INSTANCES

  UserProfile _createUpdatedProfileInstance({
    required UserProfile oldProfile,
    required String name,
    required String profilePhotoUrl,
    required String? genderOther,
    required UserGender gender,
    required String bio,
    required String title,
    required DateTime birthDay,
    required String registerCountry,
  }) {
    int age = DateTime.now().year - birthDay.year;
    UserProfile updatedProfile = UserProfileEntity(
      name: name,
      userId: oldProfile.userId,
      profilePhotoUrl: profilePhotoUrl,
      gender: genderModelToGenderEntity(gender),
      genderOther: genderOther,
      bio: bio,
      registerCountry: registerCountry,
      title: title,
      createdOn: oldProfile.createdOn,
      lastUpdatedOn: DateTime.now(),
      birthDay: birthDay,
      isBanned: oldProfile.isBanned,
      age: age,
      verificationVideo: mapUserVerificationVideoModelToEntity(
          oldProfile.getVerificationVideo()),
    );
    updatedProfile.datingPhotos = oldProfile.datingPhotos;
    updatedProfile.makeMyOrientationPublic = oldProfile.makeMyOrientationPublic;
    updatedProfile.onlyShowMeOthersOfSameOrientation =
        oldProfile.onlyShowMeOthersOfSameOrientation;
    updatedProfile.minAgePreference = oldProfile.minAgePreference;
    updatedProfile.maxAgePreference = oldProfile.maxAgePreference;
    updatedProfile.setGenderPreferences(oldProfile.getGenderPreferences());
    updatedProfile
        .setUserSexualOrientation(oldProfile.getUserSexualOrientation());
    return updatedProfile;
  }

  UserProfile _createNewUserProfileInstance(
      {required String name,
      required String userId,
      required String profilePhotoUrl,
      String? genderOther,
      required UserGender gender,
      required String bio,
      required String registerCountry,
      required String title,
      required DateTime birthDay,
      bool isBanned = false,
      required UserVerificationVideo verificationVideo}) {
    int age = DateTime.now().year - birthDay.year;
    return UserProfileEntity(
        name: name,
        userId: userId,
        profilePhotoUrl: profilePhotoUrl,
        gender: genderModelToGenderEntity(gender),
        genderOther: genderOther,
        bio: bio,
        registerCountry: registerCountry,
        title: title,
        createdOn: DateTime.now(),
        lastUpdatedOn: DateTime.now(),
        birthDay: birthDay,
        isBanned: isBanned,
        age: age,
        verificationVideo:
            mapUserVerificationVideoModelToEntity(verificationVideo));
  }
}

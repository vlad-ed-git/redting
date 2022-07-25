import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/data/data_sources/local/local_profile_source.dart';
import 'package:redting/features/profile/data/data_sources/remote/remote_profile_source.dart';
import 'package:redting/features/profile/data/entities/user_gender_entity.dart';
import 'package:redting/features/profile/data/entities/user_profile_entity.dart';
import 'package:redting/features/profile/data/utils/compressors/image_compressor.dart';
import 'package:redting/features/profile/data/utils/compressors/video_compressor.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';
import 'package:redting/features/profile/domain/repositories/ProfileRepository.dart';
import 'package:redting/res/strings.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final RemoteProfileDataSource _remoteProfileDataSource;
  final LocalProfileDataSource _localProfileDataSource;
  final VideoCompressor _videoCompressor;
  final ImageCompressor _imageCompressor;

  ProfileRepositoryImpl(
      this._remoteProfileDataSource,
      this._localProfileDataSource,
      this._videoCompressor,
      this._imageCompressor);

  @override
  Future<OperationResult> createUserProfile(
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
      return OperationResult(errorOccurred: true, errorMessage: nameMissingErr);
    }
    if (userId.isEmpty) {
      return OperationResult(
          errorOccurred: true,
          errorMessage: userIdMissingDuringProfileCreateErr);
    }
    if (profilePhotoUrl.isEmpty) {
      return OperationResult(
          errorOccurred: true, errorMessage: emptyProfilePhotoErr);
    }
    if (verificationVideo == null) {
      return OperationResult(
          errorOccurred: true, errorMessage: noVerificationVideo);
    }

    if (!UserProfile.isValidGender(gender: gender, genderOther: genderOther)) {
      return OperationResult(
          errorOccurred: true, errorMessage: noGenderSpecified);
    }
    if ((bio.isEmpty || bio.length < UserProfile.userBioMinLen)) {
      return OperationResult(errorOccurred: true, errorMessage: bioIsEmptyErr);
    }
    if (title.isEmpty || title.length < UserProfile.userTitleMinLen) {
      return OperationResult(
          errorOccurred: true, errorMessage: titleIsEmptyErr);
    }
    if (title.length > UserProfile.userTitleMaxLen) {
      return OperationResult(
          errorOccurred: true, errorMessage: titleIsTooLongErr);
    }
    if (!UserProfile.isOfLegalAge(birthDay: birthDay)) {
      return OperationResult(errorOccurred: true, errorMessage: bDayNotSet);
    }

    UserProfile profile = _createUserProfileInstance(
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
        await _remoteProfileDataSource.createUserProfile(profile: profile);
    if (savedProfile == null) {
      return OperationResult(
          errorOccurred: true, errorMessage: createProfileError);
    }

    //local
    OperationResult result = await _localProfileDataSource
        .cacheAndReturnUserProfile(profile: savedProfile);
    if (result.errorOccurred) {
      return OperationResult(
          errorOccurred: true, errorMessage: createProfileError);
    }
    return result;
  }

  /// FETCH
  @override
  Future<OperationResult> getUserProfileFromRemote() async {
    //remote
    final OperationResult result =
        await _remoteProfileDataSource.getUserProfile();

    if (result.errorOccurred) return result;

    //update cache
    if (result.data is UserProfile) {
      return await _localProfileDataSource.cacheAndReturnUserProfile(
          profile: result.data as UserProfile);
    }

    return result;
  }

  /// UPLOADS
  @override
  Future<OperationResult> uploadProfilePhoto(
      {required File file, required String filename}) async {
    return await _remoteProfileDataSource.uploadProfilePhoto(
        file: file, filename: filename, imageCompressor: _imageCompressor);
  }

  @override
  Future<OperationResult> generateVerificationWord() async {
    return await _remoteProfileDataSource.generateVerificationWord();
  }

  @override
  Future<OperationResult> uploadVerificationVideo(
      {required File file, required String verificationCode}) async {
    return await _remoteProfileDataSource.uploadVerificationVideo(
        file: file,
        verificationCode: verificationCode,
        compressor: _videoCompressor);
  }

  @override
  Future<OperationResult> deleteVerificationVideo() async {
    return await _remoteProfileDataSource.deleteVerificationVideo();
  }

  /// INSTANCE CREATION
  UserProfile _createUserProfileInstance(
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
        gender: mapUserGenderToDataEntity(gender),
        genderOther: genderOther,
        bio: bio,
        registerCountry: registerCountry,
        title: title,
        createdOn: DateTime.now(),
        lastUpdatedOn: DateTime.now(),
        birthDay: birthDay,
        isBanned: isBanned,
        age: age,
        verificationVideo: verificationVideo);
  }

  @override
  Future<UserProfile?> getCachedUserProfile() {
    return _localProfileDataSource.getCachedUserProfile();
  }
}

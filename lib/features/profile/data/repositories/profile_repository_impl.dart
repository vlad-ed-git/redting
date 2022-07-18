import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/data/data_sources/local/local_profile_source.dart';
import 'package:redting/features/profile/data/data_sources/remote/remote_profile_source.dart';
import 'package:redting/features/profile/data/entities/user_gender_entity.dart';
import 'package:redting/features/profile/data/entities/user_profile_entity.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/repositories/ProfileRepository.dart';
import 'package:redting/res/strings.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final RemoteProfileDataSource _remoteProfileDataSource;
  final LocalProfileDataSource _localProfileDataSource;

  ProfileRepositoryImpl(
      this._remoteProfileDataSource, this._localProfileDataSource);

  @override
  Future<OperationResult> createUserProfile(
      {required String name,
      required String userId,
      required String phoneNumber,
      required String profilePhotoUrl,
      String? genderOther,
      required UserGender gender,
      required String bio,
      required String registerCountry,
      required String title,
      required DateTime birthDay,
      required String verificationVideoUrl}) async {
    UserProfile profile = _createUserProfileInstance(
        name: name,
        userId: userId,
        phoneNumber: phoneNumber,
        profilePhotoUrl: profilePhotoUrl,
        gender: gender,
        genderOther: genderOther,
        bio: bio,
        registerCountry: registerCountry,
        title: title,
        birthDay: birthDay,
        isBanned: false,
        verificationVideoUrl: verificationVideoUrl);

    //remote
    UserProfile? savedProfile =
        await _remoteProfileDataSource.createUserProfile(profile: profile);
    if (savedProfile == null) {
      return OperationResult(
          errorOccurred: true, errorMessage: createProfileError);
    }

    //local
    OperationResult result =
        await _localProfileDataSource.cacheUserProfile(profile: savedProfile);
    if (result.errorOccurred) {
      return OperationResult(
          errorOccurred: true, errorMessage: createProfileError);
    }
    return result;
  }

  UserProfile _createUserProfileInstance(
      {required String name,
      required String userId,
      required String phoneNumber,
      required String profilePhotoUrl,
      String? genderOther,
      required UserGender gender,
      required String bio,
      required String registerCountry,
      required String title,
      required DateTime birthDay,
      bool isBanned = false,
      required String verificationVideoUrl,
      DateTime? verificationVideoCreatedOn}) {
    return UserProfileEntity(
        name: name,
        userId: userId,
        phoneNumber: phoneNumber,
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
        verificationVideo: {
          verificationVideoCreatedOn ?? DateTime.now(): verificationVideoUrl
        });
  }

  @override
  Future<OperationResult> deleteUserProfile(
      {required UserProfile profile}) async {
    //remote
    OperationResult result =
        await _remoteProfileDataSource.deleteUserProfile(profile: profile);
    if (!result.errorOccurred) {
      //local
      result =
          await _localProfileDataSource.clearUserProfileCache(profile: profile);
    }

    if (result.errorOccurred) {
      return OperationResult(
          errorMessage: deleteProfileError, errorOccurred: true);
    }
    return result;
  }

  @override
  Future<OperationResult> getUserProfile() async {
    //remote
    final UserProfile? profile =
        await _remoteProfileDataSource.getUserProfile();

    //update cache
    if (profile != null) {
      await _localProfileDataSource.cacheUserProfile(profile: profile);
    }

    //always read from cache
    UserProfile? userProfile =
        await _localProfileDataSource.getCachedUserProfile();
    return OperationResult(data: userProfile);
  }

  @override
  Future<OperationResult> updateUserProfile(
      {required UserProfile oldProfile,
      String? name,
      String? profilePhotoUrl,
      String? genderOther,
      UserGender? gender,
      String? bio,
      String? title,
      DateTime? birthDay,
      String? verificationVideoUrl}) async {
    //should have at-least one
    final verificationVideoUrls =
        oldProfile.verificationVideo.values.toList(growable: false);
    final verificationVideoDates =
        oldProfile.verificationVideo.keys.toList(growable: false);

    String newVerificationVideoUrl =
        verificationVideoUrl ?? verificationVideoUrls.last;
    DateTime? newVerificationVideoCreatedOn = verificationVideoUrl != null
        ? DateTime.now()
        : verificationVideoDates.last;

    UserProfile newProfile = _createUserProfileInstance(
        name: oldProfile.name,
        userId: oldProfile.userId,
        phoneNumber: oldProfile.phoneNumber,
        profilePhotoUrl: profilePhotoUrl ?? oldProfile.profilePhotoUrl,
        gender: gender ?? oldProfile.gender,
        genderOther: genderOther ?? oldProfile.genderOther,
        bio: bio ?? oldProfile.bio,
        registerCountry: oldProfile.registerCountry,
        title: title ?? oldProfile.title,
        birthDay: birthDay ?? oldProfile.birthDay,
        isBanned: oldProfile.isBanned,
        verificationVideoCreatedOn: newVerificationVideoCreatedOn,
        verificationVideoUrl: newVerificationVideoUrl);

    //remote
    OperationResult result =
        await _remoteProfileDataSource.updateUserProfile(profile: newProfile);
    if (!result.errorOccurred) {
      //local
      result = await _localProfileDataSource.updateUserProfileCache(
          profile: newProfile);
    }

    if (result.errorOccurred) {
      return OperationResult(
          errorMessage: updateProfileError, errorOccurred: true);
    }
    return result;
  }

  @override
  Future<OperationResult> uploadProfilePhoto({required File file}) async {
    return await _remoteProfileDataSource.uploadProfilePhoto(file: file);
  }

  @override
  Future<OperationResult> generateVerificationWord() async {
    return await _remoteProfileDataSource.generateVerificationWord();
  }

  @override
  Future<OperationResult> uploadVerificationVideo({required File file}) async {
    return await _remoteProfileDataSource.uploadVerificationVideo(file: file);
  }
}

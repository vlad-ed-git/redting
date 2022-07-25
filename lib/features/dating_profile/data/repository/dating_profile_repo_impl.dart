import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/data/data_sources/local/local_dating_profile_source.dart';
import 'package:redting/features/dating_profile/data/data_sources/remote/remote_dating_profile_source.dart';
import 'package:redting/features/dating_profile/data/entities/dating_profile_entity.dart';
import 'package:redting/features/dating_profile/data/entities/sexual_orientation_entity.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/dating_profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/dating_profile/domain/repository/dating_profile_repo.dart';
import 'package:redting/features/profile/data/entities/user_gender_entity.dart';
import 'package:redting/features/profile/data/utils/compressors/image_compressor.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/res/strings.dart';

class DatingProfileRepoImpl implements DatingProfileRepo {
  final RemoteDatingProfileSource _remoteSource;
  final LocalDatingProfileSource _localSource;
  final ImageCompressor _imageCompressor;

  DatingProfileRepoImpl(
    this._remoteSource,
    this._localSource,
    this._imageCompressor,
  );

  @override
  Future<OperationResult> addPhoto(
      File photo, String filename, String userId) async {
    String? downloadUrl = await _remoteSource.uploadPhoto(
        photo, filename, userId, _imageCompressor);
    return downloadUrl != null
        ? OperationResult(data: downloadUrl)
        : OperationResult(
            errorOccurred: true, errorMessage: uploadingDatingProfilePhotoErr);
  }

  /// DATING PROFILE
  @override
  Future<OperationResult> createDatingProfile(
      String userId,
      List<File> photoFiles,
      List<String> photoFileNames,
      int minAgePreference,
      int maxAgePreference,
      UserGender? genderPreference,
      List<SexualOrientation> userOrientation,
      bool makeMyOrientationPublic,
      bool onlyShowMeOthersOfSameOrientation) async {
    List<String> photos = [];

    //upload the files
    int i = 0;
    for (File file in photoFiles) {
      OperationResult result = await addPhoto(file, photoFileNames[i], userId);
      if (result.data is String) {
        photos.add(result.data);
      }
      i++;
    }

    if (userOrientation.isEmpty) {
      //default orientation
      userOrientation.add(SexualOrientation.straight);
    }
    DatingProfile profile = createDatingProfileInstance(
        userId,
        photos,
        minAgePreference,
        maxAgePreference,
        genderPreference,
        userOrientation,
        makeMyOrientationPublic,
        onlyShowMeOthersOfSameOrientation);
    DatingProfile? createdProfile =
        await _remoteSource.createDatingProfile(profile);
    if (createdProfile == null) {
      return OperationResult(
          errorOccurred: true, errorMessage: createDatingProfileErr);
    }
    return await _localSource.cacheDatingProfileAndGetIt(createdProfile);
  }

  @override
  Future<OperationResult> getDatingProfileFromRemote(String userId) async {
    OperationResult result = await _remoteSource.getDatingProfile(userId);
    if (result.errorOccurred) return result;

    //cache
    if (result.data is DatingProfile) {
      return await _localSource
          .cacheDatingProfileAndGetIt(result.data as DatingProfile);
    }

    DatingProfile? cachedProfile = await _localSource.getCachedDatingProfile();
    return OperationResult(data: cachedProfile);
  }

  @override
  Future<DatingProfile?> getCachedDatingProfile() {
    return _localSource.getCachedDatingProfile();
  }

  @override
  Future<OperationResult> updateDatingProfile(
      String userId,
      List<String> photos,
      int minAgePreference,
      int maxAgePreference,
      UserGender? genderPreference,
      List<SexualOrientation> userOrientation,
      bool makeMyOrientationPublic,
      bool onlyShowMeOthersOfSameOrientation) async {
    DatingProfile profile = createDatingProfileInstance(
        userId,
        photos,
        minAgePreference,
        maxAgePreference,
        genderPreference,
        userOrientation,
        makeMyOrientationPublic,
        onlyShowMeOthersOfSameOrientation);

    DatingProfile? updatedProfile =
        await _remoteSource.updateDatingProfile(profile);
    if (updatedProfile == null) {
      return OperationResult(
          errorOccurred: true, errorMessage: updateDatingProfileErr);
    }
    return await _localSource.updateDatingProfileCacheAndGetIt(updatedProfile);
  }

  /// create instance
  DatingProfile createDatingProfileInstance(
      String userId,
      List<String> photos,
      int minAgePreference,
      int maxAgePreference,
      UserGender? genderPreference,
      List<SexualOrientation> userOrientation,
      bool makeMyOrientationPublic,
      bool onlyShowMeOthersOfSameOrientation) {
    return DatingProfileEntity(
      makeMyOrientationPublic: makeMyOrientationPublic,
      onlyShowMeOthersOfSameOrientation: onlyShowMeOthersOfSameOrientation,
      userOrientation:
          userOrientation.map((e) => mapSexualOrientationToEntity(e)).toList(),
      photos: photos,
      maxAgePreference: maxAgePreference,
      minAgePreference: minAgePreference,
      userId: userId,
      genderPreference: genderPreference != null
          ? mapUserGenderToDataEntity(genderPreference)
          : null,
    );
  }
}

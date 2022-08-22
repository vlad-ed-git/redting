import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';
import 'package:redting/features/profile/domain/utils/dating_pic.dart';

abstract class ProfileRepository {
  Future<ServiceResult> loadUserProfileFromRemoteIfExists();
  Future<UserProfile?> getCachedUserProfile();

  Future<ServiceResult> createUserProfile({
    required String name,
    required String userId,
    required String profilePhotoUrl,
    String? genderOther,
    required UserGender gender,
    required String bio,
    required String title,
    required DateTime? birthDay,
    required String registerCountry,
    required UserVerificationVideo? verificationVideo,
  });

  Future<ServiceResult> uploadProfilePhoto({
    required File file,
    required String filename,
  });

  Future<ServiceResult> uploadVerificationVideo(
      {required File file, required String verificationCode});
  Future<ServiceResult> generateVerificationWord();
  Future<ServiceResult> deleteVerificationVideo();

  Future<ServiceResult> addDatingPhoto(
      File photo, String filename, String userId);
  Future<ServiceResult> setDatingInfo(
      UserProfile profile,
      List<DatingPic> datingPics,
      int minAgePreference,
      int maxAgePreference,
      UserGender? genderPreference,
      List<SexualOrientation> userOrientation,
      bool makeMyOrientationPublic,
      bool onlyShowMeOthersOfSameOrientation);

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
  });
}

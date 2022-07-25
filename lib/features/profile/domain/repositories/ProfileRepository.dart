import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';

abstract class ProfileRepository {
  Future<OperationResult> getUserProfileFromRemote();
  Future<UserProfile?> getCachedUserProfile();

  Future<OperationResult> createUserProfile({
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

  Future<OperationResult> uploadProfilePhoto({
    required File file,
    required String filename,
  });

  Future<OperationResult> uploadVerificationVideo(
      {required File file, required String verificationCode});
  Future<OperationResult> generateVerificationWord();
  Future<OperationResult> deleteVerificationVideo();
}

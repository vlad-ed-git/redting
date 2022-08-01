import 'dart:io';

import 'package:redting/features/profile/data/utils/compressors/image_compressor.dart';
import 'package:redting/features/profile/data/utils/compressors/video_compressor.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';

abstract class RemoteProfileDataSource {
  Future<UserProfile?> getUserProfile();
  Future<UserProfile?> updateUserProfile({required UserProfile profile});
  Future<UserProfile?> createUserProfile({required UserProfile profile});
  Future<String?> uploadProfilePhoto(
      {required File file,
      required String filename,
      required ImageCompressor imageCompressor});
  Future<UserVerificationVideo?> compressAndUploadVerificationVideo(
      {required File file,
      required String verificationCode,
      required VideoCompressor compressor});
  Future<String?> generateVerificationWord();
  Future<bool> deleteVerificationVideo();
  Future<String?> uploadDatingPhoto(File photo, String filename, String userId,
      ImageCompressor imageCompressor);
}

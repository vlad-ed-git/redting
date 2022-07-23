import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/data/utils/compressors/image_compressor.dart';
import 'package:redting/features/profile/data/utils/compressors/video_compressor.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

abstract class RemoteProfileDataSource {
  Future<OperationResult> getUserProfile();
  Future<OperationResult> updateUserProfile({required UserProfile profile});
  Future<UserProfile?> createUserProfile({required UserProfile profile});
  Future<OperationResult> uploadProfilePhoto(
      {required File file,
      required String filename,
      required ImageCompressor imageCompressor});
  Future<OperationResult> uploadVerificationVideo(
      {required File file,
      required String verificationCode,
      required VideoCompressor compressor});
  Future<OperationResult> generateVerificationWord();
  Future<OperationResult> deleteVerificationVideo();
}

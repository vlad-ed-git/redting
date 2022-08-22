import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/repositories/profile_repository.dart';

class UploadVerificationVideoUseCase {
  final ProfileRepository profileRepository;
  UploadVerificationVideoUseCase({required this.profileRepository});

  Future<ServiceResult> execute(
      {required File file, required String verificationCode}) async {
    return await profileRepository.uploadVerificationVideo(
        file: file, verificationCode: verificationCode);
  }
}

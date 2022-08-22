import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/repositories/profile_repository.dart';

class UploadProfilePhotoUseCase {
  final ProfileRepository profileRepository;
  UploadProfilePhotoUseCase({required this.profileRepository});

  Future<ServiceResult> execute(
      {required File file, required String filename}) async {
    return await profileRepository.uploadProfilePhoto(
        file: file, filename: filename);
  }
}

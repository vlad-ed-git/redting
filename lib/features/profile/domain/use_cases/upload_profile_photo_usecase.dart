import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/repositories/ProfileRepository.dart';

class UploadProfilePhotoUseCase {
  final ProfileRepository profileRepository;
  UploadProfilePhotoUseCase({required this.profileRepository});

  Future<OperationResult> execute({required File file}) async {
    return await profileRepository.uploadProfilePhoto(file: file);
  }
}

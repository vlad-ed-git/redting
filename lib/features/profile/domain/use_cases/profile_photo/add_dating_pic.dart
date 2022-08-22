import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/repositories/profile_repository.dart';

class AddDatingPicUseCase {
  final ProfileRepository repository;
  AddDatingPicUseCase(
    this.repository,
  );

  Future<ServiceResult> execute(
      File photo, String filename, String userId) async {
    return await repository.addDatingPhoto(photo, filename, userId);
  }
}

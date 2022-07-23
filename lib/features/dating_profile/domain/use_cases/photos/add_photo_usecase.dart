import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/domain/repository/dating_profile_repo.dart';

class AddPhotoUseCase {
  final DatingProfileRepo _repository;
  AddPhotoUseCase(
    this._repository,
  );

  Future<OperationResult> execute(
      File photo, String filename, String userId) async {
    return await _repository.addPhoto(photo, filename, userId);
  }
}

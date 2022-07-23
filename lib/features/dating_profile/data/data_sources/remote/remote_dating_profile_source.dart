import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/profile/data/utils/compressors/image_compressor.dart';

abstract class RemoteDatingProfileSource {
  Future<String?> uploadPhoto(File photo, String filename, String userId,
      ImageCompressor imageCompressor);
  Future<OperationResult> getDatingProfile(String userId);
  Future<DatingProfile?> updateDatingProfile(DatingProfile profile);
  Future<DatingProfile?> createDatingProfile(DatingProfile profile);
}

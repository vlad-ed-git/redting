import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

abstract class RemoteProfileDataSource {
  Future<UserProfile?> getUserProfile();
  Future<OperationResult> updateUserProfile({required UserProfile profile});
  Future<OperationResult> deleteUserProfile({required UserProfile profile});
  Future<UserProfile?> createUserProfile({required UserProfile profile});
  Future<OperationResult> uploadProfilePhoto(
      {required File file, required String filename});
  Future<OperationResult> uploadVerificationVideo({required File file});
  Future<OperationResult> generateVerificationWord();
}

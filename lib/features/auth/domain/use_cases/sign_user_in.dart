import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/domain/repositories/auth_repository.dart';

class SignUserInUseCase {
  final AuthRepository repository;
  SignUserInUseCase({required this.repository});

  Future<ServiceResult> execute(
      {String? verificationId, String? smsCode, dynamic credential}) async {
    return await repository.signInUser(verificationId, smsCode, credential);
  }
}

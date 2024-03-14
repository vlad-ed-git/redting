import 'package:redting/features/auth/data/utils/phone_verification_result.dart';
import 'package:redting/features/auth/domain/repositories/auth_repository.dart';

class SendVerificationCodeUseCase {
  final AuthRepository repository;
  SendVerificationCodeUseCase({required this.repository});

  execute(
      {required phone,
      required code,
      int? resendToken,
      required Function(PhoneVerificationResult result) callback}) {
    return repository.sendVerificationCode(phone, code, resendToken, callback);
  }
}

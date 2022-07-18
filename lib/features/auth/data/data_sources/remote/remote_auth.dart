import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/data/utils/phone_verification_result.dart';

abstract class RemoteAuthSource {
  OperationResult getAuthUser();
  Future signUserOut();
  void sendVerificationCodeToPhone(String phone, String countryCode,
      int? resendToken, Function(PhoneVerificationResult result) callback);
  Future<OperationResult> signInWithCredentials(dynamic credential);
  Future<OperationResult> signInWithVerificationCode(
      String verificationId, String smsCode);
}

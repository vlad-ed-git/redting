import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/data/utils/phone_verification_result.dart';

abstract class RemoteAuthSource {
  ServiceResult getAuthUser();
  Future signUserOut();
  void sendVerificationCodeToPhone(String phone, String countryCode,
      int? resendToken, Function(PhoneVerificationResult result) callback);
  Future<ServiceResult> signInWithCredentials(dynamic credential);
  Future<ServiceResult> signInWithVerificationCode(
      String verificationId, String smsCode);
}

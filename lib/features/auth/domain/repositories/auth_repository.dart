import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/data/utils/phone_verification_result.dart';

abstract class AuthRepository {
  Future<ServiceResult> getCachedAuthUser();
  Future signOut();
  void sendVerificationCode(String phone, String countryCode, int? resendToken,
      Function(PhoneVerificationResult result) callback);
  Future<ServiceResult> signInUser(
      String? verificationId, String? smsCode, dynamic credential);
}

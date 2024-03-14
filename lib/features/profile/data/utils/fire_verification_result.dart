import 'package:redting/features/auth/data/utils/phone_verification_result.dart';

class FireAuthSendCodeResult implements PhoneVerificationResult {
  @override
  dynamic credential;

  @override
  String? errMsg;

  @override
  bool errorOccurred;

  @override
  bool isAutoVerified;

  @override
  bool isCodeSent;

  @override
  int? resendToken;

  @override
  String? verificationId;

  FireAuthSendCodeResult(
      {this.credential,
      this.errMsg,
      this.errorOccurred = false,
      this.isAutoVerified = false,
      this.isCodeSent = false,
      this.resendToken,
      this.verificationId});
}

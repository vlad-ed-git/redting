abstract class PhoneVerificationResult {
  dynamic credential;
  String? verificationId;
  int? resendToken;
  bool isCodeSent;
  bool isAutoVerified;
  bool errorOccurred;
  String? errMsg;

  PhoneVerificationResult(
      {this.errorOccurred = false,
      this.errMsg,
      this.resendToken,
      this.isCodeSent = false,
      this.verificationId,
      this.isAutoVerified = false,
      this.credential});
}

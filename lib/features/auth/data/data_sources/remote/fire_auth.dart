import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/data/data_sources/remote/remote_auth.dart';
import 'package:redting/features/auth/data/entities/auth_user_entity.dart';
import 'package:redting/features/auth/data/utils/fire_verification_result.dart';
import 'package:redting/res/strings.dart';

class FireAuth implements RemoteAuthSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  ServiceResult getAuthUser() {
    try {
      User? user = _auth.currentUser;
      if (user == null) return ServiceResult();

      return ServiceResult(
          data: AuthUserEntity(
        userId: user.uid,
        phoneNumber: user.phoneNumber!,
      ));
    } catch (e) {
      /// probably phone number is unset
      return ServiceResult(errorOccurred: true, errorMessage: "$e");
    }
  }

  @override
  void sendVerificationCodeToPhone(String phone, String countryCode,
      int? resendToken, Function(FireAuthSendCodeResult result) callback) {
    String formattedPhone = (countryCode + phone).replaceAll(" ", "");

    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: formattedPhone,
      timeout: const Duration(seconds: 60),
      forceResendingToken: resendToken,
      verificationCompleted: (PhoneAuthCredential credential) {
        //android only
        callback(FireAuthSendCodeResult(
            isAutoVerified: true, credential: credential));
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          callback(FireAuthSendCodeResult(
              errorOccurred: true, errMsg: phoneNumberErr));
        } else {
          callback(FireAuthSendCodeResult(
              errMsg: unknownCodeSendingErr, errorOccurred: true));
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        callback(FireAuthSendCodeResult(
            isCodeSent: true,
            verificationId: verificationId,
            resendToken: resendToken));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Future<ServiceResult> signInWithCredentials(dynamic credential) async {
    try {
      UserCredential userCredentials =
          await _auth.signInWithCredential(credential as PhoneAuthCredential);

      return ServiceResult(data: userCredentials);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-verification-code") {
        return ServiceResult(
            errorOccurred: true, errorMessage: invalidVerificationCode);
      }

      return ServiceResult(
          errorOccurred: true, errorMessage: failedToVerifyUnknown);
    }
  }

  @override
  Future<ServiceResult> signInWithVerificationCode(
      String verificationId, String smsCode) async {
    // Create a PhoneAuthCredential with the code
    if (smsCode.trim().isEmpty) {
      return ServiceResult(
          errorOccurred: true, errorMessage: invalidVerificationCode);
    }
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    return await signInWithCredentials(credential);
  }

  @override
  Future signUserOut() async {
    await _auth.signOut();
  }
}

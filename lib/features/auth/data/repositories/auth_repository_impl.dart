import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/data/data_sources/local/local_auth.dart';
import 'package:redting/features/auth/data/data_sources/remote/remote_auth.dart';
import 'package:redting/features/auth/data/utils/phone_verification_result.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/auth/domain/repositories/auth_repository.dart';
import 'package:redting/res/strings.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthSource remoteAuth;
  final LocalAuthSource localAuth;

  AuthRepositoryImpl({
    required this.remoteAuth,
    required this.localAuth,
  });

  @override
  Future<ServiceResult> getCachedAuthUser() async {
    try {
      AuthUser? authUser = localAuth.getAuthUser();
      return ServiceResult(data: authUser);
    } catch (e) {
      return ServiceResult(errorOccurred: true, errorMessage: "$e");
    }
  }

  @override
  void sendVerificationCode(String phone, String countryCode, int? resendToken,
      Function(PhoneVerificationResult result) callback) {
    remoteAuth.sendVerificationCodeToPhone(
        phone, countryCode, resendToken, callback);
  }

  @override
  Future<ServiceResult> signInUser(
      String? verificationId, String? smsCode, dynamic credential) async {
    ServiceResult result;

    //2 ways to sign
    if (verificationId != null && smsCode != null) {
      result =
          await remoteAuth.signInWithVerificationCode(verificationId, smsCode);
    } else {
      result = await remoteAuth.signInWithCredentials(credential);
    }

    if (result.errorOccurred) {
      return result;
    }

    //try and cache the user
    AuthUser? authUser = await cacheAuthUser();
    if (authUser == null) {
      await signOut(); //just to be certain
      return ServiceResult(
          errorOccurred: true, errorMessage: failedToCacheAuthUser);
    }
    return ServiceResult(data: authUser);
  }

  @override
  Future signOut() async {
    await localAuth.signUserOut();
    await remoteAuth.signUserOut();
  }

  Future<AuthUser?> cacheAuthUser() async {
    try {
      ServiceResult result = remoteAuth.getAuthUser();
      if (result.data is AuthUser) {
        AuthUser user = result.data as AuthUser;
        await localAuth.cacheAuthUser(authUser: user);
        return user;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

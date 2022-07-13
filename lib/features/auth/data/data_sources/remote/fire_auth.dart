import 'package:firebase_auth/firebase_auth.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/data/data_sources/remote/remote_auth.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';

class FireAuth implements RemoteAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  RemoteServiceResult getAuthUser() {
    try {
      User? user = _auth.currentUser;
      if (user == null) return RemoteServiceResult();

      return RemoteServiceResult(
          data: AuthUser(userId: user.uid, phoneNumber: user.phoneNumber!));
    } catch (e) {
      /// probably phone number is unset
      return RemoteServiceResult(errorOccurred: true);
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/data/data_sources/remote/remote_auth.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';

class FireAuth implements RemoteAuthSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  OperationResult getAuthUser() {
    try {
      User? user = _auth.currentUser;
      if (user == null) return OperationResult();

      return OperationResult(
          data: AuthUser(userId: user.uid, phoneNumber: user.phoneNumber!));
    } catch (e) {
      /// probably phone number is unset
      return OperationResult(errorOccurred: true);
    }
  }
}

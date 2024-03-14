import 'package:redting/features/auth/domain/models/auth_user.dart';

abstract class LocalAuthSource {
  AuthUser? getAuthUser();
  Future signUserOut();
  Future<void> cacheAuthUser({required AuthUser authUser});
}

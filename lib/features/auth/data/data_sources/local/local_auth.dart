import 'package:redting/features/auth/domain/models/auth_user.dart';

abstract class LocalAuth {
  AuthUser? getAuthUser();

  Future<void> cacheAuthUser({required AuthUser authUser});
}

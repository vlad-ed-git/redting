import 'package:redting/features/auth/domain/models/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser?> getAuthUser();
}

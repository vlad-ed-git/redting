import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/data/data_sources/local/local_auth.dart';
import 'package:redting/features/auth/data/data_sources/remote/remote_auth.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuth remoteAuth;
  final LocalAuth localAuth;

  AuthRepositoryImpl({
    required this.remoteAuth,
    required this.localAuth,
  });

  @override
  Future<AuthUser?> getAuthUser() async {
    RemoteServiceResult result = remoteAuth.getAuthUser();
    if (result.data is AuthUser) {
      await localAuth.cacheAuthUser(authUser: result.data);
    }
    return localAuth.getAuthUser();
  }
}

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/data/data_sources/local/local_auth.dart';
import 'package:redting/features/auth/data/data_sources/remote/remote_auth.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthSource remoteAuth;
  final LocalAuthSource localAuth;

  AuthRepositoryImpl({
    required this.remoteAuth,
    required this.localAuth,
  });

  @override
  Future<OperationResult> getAuthUser() async {
    OperationResult result = remoteAuth.getAuthUser();
    if (result.errorOccurred) return result;

    if (result.data is AuthUser) {
      await localAuth.cacheAuthUser(authUser: result.data);
    }
    return OperationResult(data: localAuth.getAuthUser());
  }
}

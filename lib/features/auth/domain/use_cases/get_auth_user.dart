import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/auth/domain/repositories/auth_repository.dart';

class GetAuthenticatedUserCase {
  final AuthRepository repository;
  GetAuthenticatedUserCase(this.repository);

  Future<AuthUser?> call() async {
    return await repository.getAuthUser();
  }
}

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/domain/repositories/auth_repository.dart';

class GetAuthenticatedUserCase {
  final AuthRepository repository;
  GetAuthenticatedUserCase({required this.repository});

  Future<ServiceResult> execute() async {
    return await repository.getCachedAuthUser();
  }
}

import 'package:redting/core/utils/service_result.dart';

abstract class AuthRepository {
  Future<OperationResult> getAuthUser();
}

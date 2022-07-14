import 'package:redting/core/utils/service_result.dart';

abstract class RemoteAuthSource {
  OperationResult getAuthUser();
}

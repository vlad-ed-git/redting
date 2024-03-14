import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/blind_date_setup/domain/model/blind_date.dart';

abstract class RemoteBlindDateSetupSource {
  Future<ServiceResult> getBlindSetupsDoneByUser(AuthUser user);
  Future<ServiceResult> setupBlindDate(BlindDate blindDate);
  Future<Map<String, String?>?> getIdsOfBlindDateParties(
      String user1PhoneNumber, String user2PhoneNumber);
  Stream<List<OperationRealTimeResult>> listenToRecentBlindDates(
    String userId,
  );
  Future<List<BlindDate>> loadOldBlindDates(String userId);
}

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/blind_date_setup/domain/model/blind_date.dart';
import 'package:redting/features/matching/domain/models/ice_breaker_msg.dart';

abstract class BlindDateRepo {
  Future<ServiceResult> getAuthUserUseCase();
  Future<ServiceResult> canSetupBlindDate(AuthUser user);
  Future<ServiceResult> setupBlindDate(AuthUser authUser, String phoneNumber1,
      String phoneNumber2, String iceBreaker);
  Future<IceBreakerMessages?> fetchIceBreakerMessages();
  Stream<List<OperationRealTimeResult>> listenToNewBlindDateSetups(
      String userId);
  Future<List<BlindDate>> loadOldBlindDateSetups(String userId);
}

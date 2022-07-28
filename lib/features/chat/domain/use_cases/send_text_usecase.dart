import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';

class SendPhotoUseCase {
  Future<OperationResult> execute({
    required MatchingMembers thisUser,
    required MatchingMembers thatUser,
    required String message,
  }) async {
    //todo
    return OperationResult();
  }
}

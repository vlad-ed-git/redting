import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';

class ListenToChatUseCase {
  Stream<List<OperationRealTimeResult>> execute({
    required MatchingMembers thisUser,
    required MatchingMembers thatUser,
  }) {
    return Stream.empty(); //todo
  }
}

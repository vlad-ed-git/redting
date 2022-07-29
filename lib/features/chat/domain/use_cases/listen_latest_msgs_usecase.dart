import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/chat/domain/repository/chat_repository.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';

class ListenToLatestMessagesUseCase {
  ChatRepository chatRepository;
  ListenToLatestMessagesUseCase(this.chatRepository);

  Stream<List<OperationRealTimeResult>> execute({
    required MatchingMembers thisUser,
    required MatchingMembers thatUser,
  }) {
    return chatRepository.listenToLatestMessaesBetweenUsers(thisUser, thatUser);
  }
}

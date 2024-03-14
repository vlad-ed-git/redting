import 'package:redting/features/chat/domain/models/message.dart';
import 'package:redting/features/chat/domain/repository/chat_repository.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';

class LoadOlderMessagesUseCase {
  ChatRepository chatRepository;
  LoadOlderMessagesUseCase(this.chatRepository);

  Future<List<Message>> execute({
    required MatchingMembers thisUser,
    required MatchingMembers thatUser,
  }) {
    return chatRepository.loadOlderMessages(thisUser, thatUser);
  }
}

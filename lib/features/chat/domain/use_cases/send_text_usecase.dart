import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/chat/domain/repository/chat_repository.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';

class SendTxtMessageUseCase {
  final ChatRepository chatRepository;
  SendTxtMessageUseCase(this.chatRepository);

  Future<ServiceResult> execute({
    required MatchingMembers thisUser,
    required MatchingMembers thatUser,
    required String message,
  }) async {
    return await chatRepository.encryptAndSendTextMessage(
        thisUser: thisUser, thatUser: thatUser, message: message);
  }
}

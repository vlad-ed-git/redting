import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/chat/domain/repository/chat_repository.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';

class SendPhotoUseCase {
  final ChatRepository chatRepository;
  SendPhotoUseCase(this.chatRepository);

  Future<OperationResult> execute({
    required MatchingMembers thisUser,
    required MatchingMembers thatUser,
    required File imageFile,
    required String imageFileName,
  }) async {
    return chatRepository.sendImageMessage(
        thisUser: thisUser,
        thatUser: thatUser,
        imageFile: imageFile,
        imageFileName: imageFileName);
  }
}

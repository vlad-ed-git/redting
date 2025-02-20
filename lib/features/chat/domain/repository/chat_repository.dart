import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/chat/domain/models/message.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';

abstract class ChatRepository {
  Future<ServiceResult> encryptAndSendTextMessage({
    required MatchingMembers thisUser,
    required MatchingMembers thatUser,
    required String message,
  });

  Future<ServiceResult> sendImageMessage({
    required MatchingMembers thisUser,
    required MatchingMembers thatUser,
    required File imageFile,
    required String imageFileName,
  });

  Stream<List<OperationRealTimeResult>> listenToLatestMessagesBetweenUsers(
      MatchingMembers thisUser, MatchingMembers thatUser);

  Future<List<Message>> loadOlderMessages(
      MatchingMembers thisUser, MatchingMembers thatUser);
}

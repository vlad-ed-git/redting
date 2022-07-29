import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/chat/domain/models/message.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';

abstract class ChatRepository {
  Future<OperationResult> encryptAndSendTextMessage({
    required MatchingMembers thisUser,
    required MatchingMembers thatUser,
    required String message,
  });

  Future<OperationResult> sendImageMessage({
    required MatchingMembers thisUser,
    required MatchingMembers thatUser,
    required File imageFile,
    required String imageFileName,
  });

  Stream<List<OperationRealTimeResult>> listenToLatestMessaesBetweenUsers(
      MatchingMembers thisUser, MatchingMembers thatUser);

  Future<List<Message>> loadOlderMessages(
      MatchingMembers thisUser, MatchingMembers thatUser);
}

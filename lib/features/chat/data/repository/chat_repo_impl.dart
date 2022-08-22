import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/chat/data/data_sources/remote/remote_chat_source.dart';
import 'package:redting/features/chat/data/entities/message_entity.dart';
import 'package:redting/features/chat/domain/models/message.dart';
import 'package:redting/features/chat/domain/repository/chat_repository.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';
import 'package:redting/features/profile/data/utils/compressors/image_compressor.dart';
import 'package:redting/res/strings.dart';

class ChatRepositoryImpl implements ChatRepository {
  final RemoteChatSource remoteSource;
  final ImageCompressor imageCompressor;

  ChatRepositoryImpl(
      {required this.remoteSource, required this.imageCompressor});

  @override
  Stream<List<OperationRealTimeResult>> listenToLatestMessagesBetweenUsers(
      MatchingMembers thisUser, MatchingMembers thatUser) {
    String chatRoomId = Message.getChatRoomId(thisUser.userId, thatUser.userId);
    //since we are getting the very first batch
    remoteSource.resetChatRoomPageTracker(chatRoomId);
    return remoteSource.listenToChatStreamBetweenUsers(chatRoomId);
  }

  @override
  Future<List<Message>> loadOlderMessages(
      MatchingMembers thisUser, MatchingMembers thatUser) {
    String chatRoomId = Message.getChatRoomId(thisUser.userId, thatUser.userId);
    return remoteSource.loadOldMessages(chatRoomId);
  }

  @override
  Future<ServiceResult> sendImageMessage(
      {required MatchingMembers thisUser,
      required MatchingMembers thatUser,
      required File imageFile,
      required String imageFileName}) async {
    try {
      String? downloadUrl = await remoteSource.uploadPhoto(
          thisUser.userId, imageFile, imageFileName, imageCompressor);
      if (downloadUrl == null) {
        //failed
        return ServiceResult(
            errorOccurred: true, errorMessage: errorSendingImageMessage);
      }

      String chatRoomId =
          Message.getChatRoomId(thisUser.userId, thatUser.userId);
      Message message = MessageEntity(
          uid: "",
          chatRoomId: chatRoomId,
          isTxt: false,
          isImage: true,
          sentAt: DateTime.now(),
          sentBy: thisUser.userId,
          sentTo: thatUser.userId,
          imageUrl: downloadUrl);
      return await remoteSource.setIdAndSendMessage(message);
    } catch (e) {
      if (kDebugMode) {
        print("============ sendImageMessage exc $e =========");
      }
      return ServiceResult(
          errorOccurred: true, errorMessage: errorSendingImageMessage);
    }
  }

  @override
  Future<ServiceResult> encryptAndSendTextMessage(
      {required MatchingMembers thisUser,
      required MatchingMembers thatUser,
      required String message}) async {
    try {
      String chatRoomId =
          Message.getChatRoomId(thisUser.userId, thatUser.userId);

      String? encryptedMsg = Message.encryptMsg(message);
      Message messageObj = MessageEntity(
          uid: "",
          chatRoomId: chatRoomId,
          isTxt: true,
          isImage: false,
          sentAt: DateTime.now(),
          sentBy: thisUser.userId,
          sentTo: thatUser.userId,
          message: encryptedMsg!);
      return await remoteSource.setIdAndSendMessage(messageObj);
    } catch (e) {
      if (kDebugMode) {
        print("============ sendTextMessage exc $e =========");
      }
      return ServiceResult(
          errorOccurred: true, errorMessage: errorSendingTxtMessage);
    }
  }
}

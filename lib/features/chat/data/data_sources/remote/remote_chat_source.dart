import 'dart:io';

import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/chat/domain/models/message.dart';
import 'package:redting/features/profile/data/utils/compressors/image_compressor.dart';

abstract class RemoteChatSource {
  Future<String?> uploadPhoto(String userId, File imageFile,
      String imageFileName, ImageCompressor imageCompressor);
  Future<ServiceResult> setIdAndSendMessage(Message message);
  Stream<List<OperationRealTimeResult>> listenToChatStreamBetweenUsers(
      String chatRoomId);
  Future<List<Message>> loadOldMessages(String chatRoomId);
  resetChatRoomPageTracker(String chatRoomId);
}

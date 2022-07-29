import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:redting/core/utils/consts.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/chat/data/data_sources/remote/remote_chat_source.dart';
import 'package:redting/features/chat/data/entities/message_entity.dart';
import 'package:redting/features/chat/domain/models/message.dart';
import 'package:redting/features/profile/data/utils/compressors/image_compressor.dart';

const String chatPhotosBucket = "chats_bucket";
const String chatRoomPhotosBucket = "chat_room_bucket";
const String chatsCollection = "chats";
const String messagesSubCollection = "messages";

class FireChat implements RemoteChatSource {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  //for pagination
  final Map<String, DocumentSnapshot<Object?>> _chatRoomLastDocFetched = {};

  @override
  Future<OperationResult> setIdAndSendMessage(Message message) async {
    try {
      var doc = _fireStore
          .collection(chatsCollection)
          .doc(message.chatRoomId)
          .collection(messagesSubCollection)
          .doc();
      message.uid = doc.id;
      await doc.set(message.toJson());
      return OperationResult();
    } catch (e) {
      if (kDebugMode) {
        print("================ setIdAndSendMessage exc $e ===========");
      }
      return OperationResult(errorOccurred: true);
    }
  }

  @override
  Future<String?> uploadPhoto(String userId, File imageFile,
      String imageFileName, ImageCompressor imageCompressor) async {
    try {
      final fileToUpload =
          await imageCompressor.compressImageAndGetCompressedOrOg(imageFile);
      final storageRef = _storage.ref();
      final photoRef = storageRef.child(
          "$chatPhotosBucket/$userId/$chatRoomPhotosBucket/${DateTime.now().millisecondsSinceEpoch.toString()}_$imageFileName");
      await photoRef.putFile(fileToUpload);
      String downloadUrl = await photoRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  /// ** listen to messages ***/
  @override
  Future<List<Message>> loadOldMessages(String chatRoomId) async {
    try {
      if (!_chatRoomLastDocFetched.containsKey(chatRoomId)) {
        return [];
      }

      QuerySnapshot<Map<String, dynamic>> results = await _fireStore
          .collection(chatsCollection)
          .doc(chatRoomId)
          .collection(messagesSubCollection)
          .orderBy(MessageEntity.orderByFieldName, descending: true)
          .startAfterDocument(_chatRoomLastDocFetched[chatRoomId]!)
          .limit(queryPageResultsSize)
          .get();

      if (results.docs.isNotEmpty) {
        _chatRoomLastDocFetched[chatRoomId] = results.docs.last;
        return results.docs
            .map((e) => MessageEntity.fromJson(e.data()))
            .toList(growable: false);
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print("============= load older messages exc $e ========");
      }
      return [];
    }
  }

  @override
  resetChatRoomPaginatorTracker(String chatRoomId) {
    if (_chatRoomLastDocFetched.containsKey(chatRoomId)) {
      _chatRoomLastDocFetched.remove(chatRoomId);
    }
  }

  @override
  Stream<List<OperationRealTimeResult>> listenToChatStreamBetweenUsers(
      String chatRoomId,
      {bool loadMore = false}) {
    try {
      Query<Map<String, dynamic>> query = _fireStore
          .collection(chatsCollection)
          .doc(chatRoomId)
          .collection(messagesSubCollection)
          .orderBy(MessageEntity.orderByFieldName, descending: true)
          .limit(queryPageResultsSize);
      return query.snapshots().map((event) {
        return _mapSnapshotsToRealTimeResultList(chatRoomId, event);
      });
    } catch (e) {
      if (kDebugMode) {
        print("=============== listen to messages $e =========");
      }
      return const Stream.empty();
    }
  }

  List<OperationRealTimeResult> _mapSnapshotsToRealTimeResultList(
      String chatRoomId, QuerySnapshot<Map<String, dynamic>> event) {
    List<OperationRealTimeResult> results = [];
    for (var change in event.docChanges) {
      MessageEntity msgReceived = MessageEntity.fromJson(change.doc.data()!);
      OperationRealTimeResult result;
      switch (change.type) {
        case DocumentChangeType.added:
          //cache the last added for pagination
          _chatRoomLastDocFetched[chatRoomId] = change.doc;
          result = OperationRealTimeResult(
            data: msgReceived,
            realTimeEventType: RealTimeEventType.added,
          );
          break;
        case DocumentChangeType.modified:
          result = OperationRealTimeResult(
            data: msgReceived,
            realTimeEventType: RealTimeEventType.modified,
          );
          break;
        case DocumentChangeType.removed:
          //reset pagination cache
          if (_chatRoomLastDocFetched.containsKey(chatRoomId)) {
            if (_chatRoomLastDocFetched[chatRoomId] == change.doc) {
              _chatRoomLastDocFetched.remove(chatRoomId);
            }
          }
          result = OperationRealTimeResult(
            data: msgReceived,
            realTimeEventType: RealTimeEventType.deleted,
          );
          break;
      }
      results.add(result);
    }
    return results;
  }
}

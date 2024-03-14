import 'package:redting/features/chat/utils/encrypt_txt_msg.dart';

abstract class Message {
  bool isImage;
  bool isTxt;
  String sentBy;
  String sentTo;
  DateTime sentAt;
  String? message;
  String? imageUrl;
  String uid;
  String chatRoomId;
  Message(
      {required this.uid,
      required this.isImage,
      required this.isTxt,
      required this.sentBy,
      required this.sentTo,
      required this.sentAt,
      this.message,
      this.imageUrl,
      required this.chatRoomId});

  Map<String, dynamic> toJson();
  Message fromJson(Map<String, dynamic> json);
  static String getChatRoomId(String user1, user2) {
    String concatUser1User2 = "$user1$user2";
    final concatUser1User2List = concatUser1User2.split("");
    concatUser1User2List.sort((a, b) => a.compareTo(b));
    return concatUser1User2List.join("");
  }

  static String? decryptMsg(String? msg) {
    if (msg == null) return null;
    return EncryptTxtMessage.decryptTxtMessage(msg);
  }

  static String? encryptMsg(String message) {
    return EncryptTxtMessage.encryptTxtMessage(message);
  }
}

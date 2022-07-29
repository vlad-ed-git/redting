part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ListenToChatEvent extends ChatEvent {
  final MatchingMembers thisUser;
  final MatchingMembers thatUser;
  ListenToChatEvent({
    required this.thisUser,
    required this.thatUser,
  });
}

class LoadMoreMessagesEvent extends ChatEvent {
  final MatchingMembers thisUser;
  final MatchingMembers thatUser;
  LoadMoreMessagesEvent({
    required this.thisUser,
    required this.thatUser,
  });
}

class SendMessageEvent extends ChatEvent {
  final String? message;
  final File? imageFile;
  final String? imageFileName;
  final MatchingMembers thisUser;
  final MatchingMembers thatUser;
  SendMessageEvent(
      {required this.thisUser,
      required this.thatUser,
      this.message,
      this.imageFile,
      this.imageFileName});
}

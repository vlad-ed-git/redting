part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ListeningToChatState extends ChatState {
  final Stream<List<OperationRealTimeResult>> stream;
  ListeningToChatState(this.stream);
}

class LoadedOlderMessagesState extends ChatState {
  final List<Message> messages;
  LoadedOlderMessagesState(this.messages);
}

class SendingMessageState extends ChatState {}

class SendingMessageFailedState extends ChatState {
  final String errMsg;
  SendingMessageFailedState(this.errMsg);
}

class SendingMessageSuccessState extends ChatState {}

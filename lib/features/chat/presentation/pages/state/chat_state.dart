part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ListeningToChatState extends ChatState {
  final Stream<List<OperationRealTimeResult>> stream;
  ListeningToChatState(this.stream);
}

class SendingMessageState extends ChatState {}

class SendingMessageFailedState extends ChatState {}

class SendingMessageSuccessState extends ChatState {}

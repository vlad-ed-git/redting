import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/chat/domain/models/message.dart';
import 'package:redting/features/chat/domain/use_cases/chat_use_cases.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';
import 'package:redting/res/strings.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatUseCases chatUseCases;
  ChatBloc(this.chatUseCases) : super(ChatInitialState()) {
    on<SendMessageEvent>(_onSendMessageEvent);
    on<ListenToChatEvent>(_onListenToChatEvent);
    on<LoadMoreMessagesEvent>(_onLoadMoreMessagesEvent);
  }

  FutureOr<void> _onSendMessageEvent(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    OperationResult? result;
    if (event.message != null) {
      emit(SendingMessageState());
      result = await chatUseCases.sendTxtMessageUseCase.execute(
          thisUser: event.thisUser,
          thatUser: event.thatUser,
          message: event.message!);
    }

    if (event.imageFile != null && event.imageFileName != null) {
      emit(SendingMessageState());
      result = await chatUseCases.sendPhotoUseCase.execute(
          thisUser: event.thisUser,
          thatUser: event.thatUser,
          imageFile: event.imageFile!,
          imageFileName: event.imageFileName!);
    }

    if (result == null) {
      //should not happen
      return;
    }

    if (result.errorOccurred) {
      String defaultErr = event.imageFile != null
          ? errorSendingImageMessage
          : errorSendingTxtMessage;
      emit(SendingMessageFailedState(result.errorMessage ?? defaultErr));
    } else {
      emit(SendingMessageSuccessState());
    }
  }

  FutureOr<void> _onListenToChatEvent(
      ListenToChatEvent event, Emitter<ChatState> emit) {
    final stream = chatUseCases.listenToChatUseCase
        .execute(thisUser: event.thisUser, thatUser: event.thatUser);
    emit(ListeningToChatState(stream));
  }

  FutureOr<void> _onLoadMoreMessagesEvent(
      LoadMoreMessagesEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());
    List<Message> messages = await chatUseCases.loadOlderMessagesUseCase
        .execute(thisUser: event.thisUser, thatUser: event.thatUser);
    emit(LoadedOlderMessagesState(messages));
  }
}

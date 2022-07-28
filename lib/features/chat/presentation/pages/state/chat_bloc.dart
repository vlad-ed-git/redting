import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitialState()) {
    on<ChatEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

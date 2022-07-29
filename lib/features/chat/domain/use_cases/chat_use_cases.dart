import 'package:redting/features/chat/domain/use_cases/listen_latest_msgs_usecase.dart';
import 'package:redting/features/chat/domain/use_cases/load_older_msgs_usecase.dart';
import 'package:redting/features/chat/domain/use_cases/send_photo_usecase.dart';
import 'package:redting/features/chat/domain/use_cases/send_text_usecase.dart';

class ChatUseCases {
  final ListenToLatestMessagesUseCase listenToChatUseCase;
  final SendPhotoUseCase sendPhotoUseCase;
  final SendTxtMessageUseCase sendTxtMessageUseCase;
  final LoadOlderMessagesUseCase loadOlderMessagesUseCase;
  ChatUseCases(
      {required this.listenToChatUseCase,
      required this.sendPhotoUseCase,
      required this.sendTxtMessageUseCase,
      required this.loadOlderMessagesUseCase});
}

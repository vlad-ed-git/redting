import 'package:get_it/get_it.dart';
import 'package:redting/features/chat/data/data_sources/remote/fire_chat.dart';
import 'package:redting/features/chat/data/data_sources/remote/remote_chat_source.dart';
import 'package:redting/features/chat/data/repository/chat_repo_impl.dart';
import 'package:redting/features/chat/domain/repository/chat_repository.dart';
import 'package:redting/features/chat/domain/use_cases/chat_use_cases.dart';
import 'package:redting/features/chat/domain/use_cases/listen_latest_msgs_usecase.dart';
import 'package:redting/features/chat/domain/use_cases/load_older_msgs_usecase.dart';
import 'package:redting/features/chat/domain/use_cases/send_photo_usecase.dart';
import 'package:redting/features/chat/domain/use_cases/send_text_usecase.dart';
import 'package:redting/features/chat/presentation/pages/state/chat_bloc.dart';

GetIt init(GetIt coreDiInstance) {
  final GetIt chatDiInstance = GetIt.instance;

  chatDiInstance.registerFactory<ChatBloc>(() => ChatBloc(chatDiInstance()));

  chatDiInstance.registerLazySingleton<ChatUseCases>(() => ChatUseCases(
      listenToChatUseCase: chatDiInstance(),
      sendPhotoUseCase: chatDiInstance(),
      sendTxtMessageUseCase: chatDiInstance(),
      loadOlderMessagesUseCase: chatDiInstance()));

  chatDiInstance.registerLazySingleton<ListenToLatestMessagesUseCase>(
      () => ListenToLatestMessagesUseCase(chatDiInstance()));

  chatDiInstance.registerLazySingleton<SendPhotoUseCase>(
      () => SendPhotoUseCase(chatDiInstance()));

  chatDiInstance.registerLazySingleton<SendTxtMessageUseCase>(
      () => SendTxtMessageUseCase(chatDiInstance()));

  chatDiInstance.registerLazySingleton<LoadOlderMessagesUseCase>(
      () => LoadOlderMessagesUseCase(chatDiInstance()));

  chatDiInstance.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(
      remoteSource: chatDiInstance(), imageCompressor: coreDiInstance()));

  chatDiInstance.registerLazySingleton<RemoteChatSource>(() => FireChat());

  return chatDiInstance;
}

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

GetIt init() {
  final GetIt diInstance = GetIt.instance;

  diInstance.registerFactory<ChatBloc>(() => ChatBloc(diInstance()));

  diInstance.registerLazySingleton<ChatUseCases>(() => ChatUseCases(
      listenToChatUseCase: diInstance(),
      sendPhotoUseCase: diInstance(),
      sendTxtMessageUseCase: diInstance(),
      loadOlderMessagesUseCase: diInstance()));

  diInstance.registerLazySingleton<ListenToLatestMessagesUseCase>(
      () => ListenToLatestMessagesUseCase(diInstance()));

  diInstance.registerLazySingleton<SendPhotoUseCase>(
      () => SendPhotoUseCase(diInstance()));

  diInstance.registerLazySingleton<SendTxtMessageUseCase>(
      () => SendTxtMessageUseCase(diInstance()));

  diInstance.registerLazySingleton<LoadOlderMessagesUseCase>(
      () => LoadOlderMessagesUseCase(diInstance()));

  diInstance.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(
      remoteSource: diInstance(), imageCompressor: diInstance()));

  diInstance.registerLazySingleton<RemoteChatSource>(() => FireChat());

  return diInstance;
}

import 'package:get_it/get_it.dart';
import 'package:redting/features/matching/data/data_sources/local/hive_matching_data_source.dart';
import 'package:redting/features/matching/data/data_sources/local/local_matching_data_source.dart';
import 'package:redting/features/matching/data/data_sources/remote/fire_matching_data_source.dart';
import 'package:redting/features/matching/data/data_sources/remote/remote_matching_data_source.dart';
import 'package:redting/features/matching/data/repositories/matching_repository_impl.dart';
import 'package:redting/features/matching/domain/repositories/matching_repository.dart';
import 'package:redting/features/matching/domain/use_cases/fetch_profiles_to_match.dart';
import 'package:redting/features/matching/domain/use_cases/get_this_usersinfo_usecase.dart';
import 'package:redting/features/matching/domain/use_cases/like_user_usecase.dart';
import 'package:redting/features/matching/domain/use_cases/listen_to_matches_usecase.dart';
import 'package:redting/features/matching/domain/use_cases/matching_usecases.dart';
import 'package:redting/features/matching/domain/use_cases/pass_on_user_usecase.dart';
import 'package:redting/features/matching/domain/use_cases/send_daily_feedback.dart';
import 'package:redting/features/matching/domain/use_cases/sync_with_remote.dart';
import 'package:redting/features/matching/presentation/state/matches_listener/matches_listener_bloc.dart';
import 'package:redting/features/matching/presentation/state/matching_bloc.dart';

GetIt init() {
  GetIt diInstance = GetIt.instance;

  diInstance.registerFactory<MatchingBloc>(() => MatchingBloc(diInstance()));

  diInstance.registerFactory<MatchesListenerBloc>(
      () => MatchesListenerBloc(diInstance()));

  diInstance.registerLazySingleton<MatchingUseCases>(() => MatchingUseCases(
      syncWithRemote: diInstance(),
      fetchProfilesToMatch: diInstance(),
      likeUserUseCase: diInstance(),
      passOnUserUseCase: diInstance(),
      sendUserDailyFeedback: diInstance(),
      listenToMatchUseCase: diInstance(),
      getThisUsersInfoUseCase: diInstance()));

  diInstance.registerLazySingleton<SyncWithRemote>(
      () => SyncWithRemote(diInstance()));

  diInstance.registerLazySingleton<FetchProfilesToMatch>(
      () => FetchProfilesToMatch(diInstance()));

  diInstance.registerLazySingleton<LikeUserUseCase>(
      () => LikeUserUseCase(diInstance()));

  diInstance.registerLazySingleton<PassOnUserUseCase>(
      () => PassOnUserUseCase(diInstance()));

  diInstance.registerLazySingleton<SendUserDailyFeedback>(
      () => SendUserDailyFeedback(diInstance()));

  diInstance.registerLazySingleton<ListenToMatchUseCase>(
      () => ListenToMatchUseCase(diInstance()));

  diInstance.registerLazySingleton<GetThisUsersInfoUseCase>(
      () => GetThisUsersInfoUseCase(diInstance()));

  diInstance.registerLazySingleton<MatchingRepository>(
      () => MatchingRepositoryImpl(diInstance(), diInstance(), diInstance()));

  diInstance.registerLazySingleton<RemoteMatchingDataSource>(
      () => FireMatchingDataSource());

  diInstance.registerLazySingleton<LocalMatchingDataSource>(
      () => HiveMatchingDataSource());

  return diInstance;
}

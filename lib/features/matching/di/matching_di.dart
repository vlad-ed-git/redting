import 'package:get_it/get_it.dart';
import 'package:redting/features/matching/data/data_sources/local/hive_matching_data_source.dart';
import 'package:redting/features/matching/data/data_sources/local/local_matching_data_source.dart';
import 'package:redting/features/matching/data/data_sources/remote/fire_matching_data_source.dart';
import 'package:redting/features/matching/data/data_sources/remote/remote_matching_data_source.dart';
import 'package:redting/features/matching/data/repositories/matching_repository_impl.dart';
import 'package:redting/features/matching/domain/repositories/matching_repository.dart';
import 'package:redting/features/matching/domain/use_cases/fetch_profiles_to_match.dart';
import 'package:redting/features/matching/domain/use_cases/initialize_usecase.dart';
import 'package:redting/features/matching/domain/use_cases/like_user_usecase.dart';
import 'package:redting/features/matching/domain/use_cases/matching_usecases.dart';
import 'package:redting/features/matching/domain/use_cases/pass_on_user_usecase.dart';
import 'package:redting/features/matching/domain/use_cases/send_daily_feedback.dart';
import 'package:redting/features/matching/presentation/state/matching_bloc.dart';

GetIt init(
  GetIt profileDiInstance,
  GetIt datingProfileDiInstance,
) {
  GetIt matchingDiInstance = GetIt.instance;

  matchingDiInstance
      .registerFactory<MatchingBloc>(() => MatchingBloc(matchingDiInstance()));

  matchingDiInstance.registerLazySingleton<MatchingUseCases>(() =>
      MatchingUseCases(
          initializeUserProfilesUseCase: matchingDiInstance(),
          fetchProfilesToMatch: matchingDiInstance(),
          likeUserUseCase: matchingDiInstance(),
          passOnUserUseCase: matchingDiInstance(),
          sendUserDailyFeedback: matchingDiInstance()));

  matchingDiInstance.registerLazySingleton<InitializeUseCase>(
      () => InitializeUseCase(matchingDiInstance()));

  matchingDiInstance.registerLazySingleton<FetchProfilesToMatch>(
      () => FetchProfilesToMatch(matchingDiInstance()));

  matchingDiInstance.registerLazySingleton<LikeUserUseCase>(
      () => LikeUserUseCase(matchingDiInstance()));

  matchingDiInstance.registerLazySingleton<PassOnUserUseCase>(
      () => PassOnUserUseCase(matchingDiInstance()));

  matchingDiInstance.registerLazySingleton<SendUserDailyFeedback>(
      () => SendUserDailyFeedback(matchingDiInstance()));

  matchingDiInstance.registerLazySingleton<MatchingRepository>(() =>
      MatchingRepositoryImpl(profileDiInstance(), datingProfileDiInstance(),
          matchingDiInstance(), matchingDiInstance()));

  matchingDiInstance.registerLazySingleton<RemoteMatchingDataSource>(
      () => FireMatchingDataSource());

  matchingDiInstance.registerLazySingleton<LocalMatchingDataSource>(
      () => HiveMatchingDataSource());

  return matchingDiInstance;
}

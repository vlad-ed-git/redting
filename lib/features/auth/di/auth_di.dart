import 'package:get_it/get_it.dart';
import 'package:redting/features/auth/data/data_sources/local/auth_user_hive.dart';
import 'package:redting/features/auth/data/data_sources/local/local_auth.dart';
import 'package:redting/features/auth/data/data_sources/remote/fire_auth.dart';
import 'package:redting/features/auth/data/data_sources/remote/remote_auth.dart';
import 'package:redting/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:redting/features/auth/domain/repositories/auth_repository.dart';
import 'package:redting/features/auth/domain/use_cases/auth_use_cases.dart';
import 'package:redting/features/auth/domain/use_cases/get_auth_user.dart';
import 'package:redting/features/auth/domain/use_cases/send_verification_code.dart';
import 'package:redting/features/auth/domain/use_cases/sign_user_in.dart';
import 'package:redting/features/auth/presentation/state/auth_user_bloc.dart';

/// FACTORY - instantiated every time we request
///  SINGLETON - only a single instance is created

GetIt init() {
  final GetIt diInstance = GetIt.instance;
  //auth bloc
  diInstance.registerFactory(() => AuthUserBloc(authUseCases: diInstance()));

  //auth useCases
  diInstance.registerLazySingleton(() => AuthUseCases(
      getAuthenticatedUser: diInstance(),
      sendVerificationCodeUseCase: diInstance(),
      signUserInUseCase: diInstance()));

  //get auth use case
  diInstance.registerLazySingleton(
      () => GetAuthenticatedUserCase(repository: diInstance()));

  //get sendVerificationUseCase
  diInstance.registerLazySingleton(
      () => SendVerificationCodeUseCase(repository: diInstance()));

  //get SignUserInUseCase
  diInstance
      .registerLazySingleton(() => SignUserInUseCase(repository: diInstance()));

  //auth repository
  diInstance.registerLazySingleton<AuthRepository>(() =>
      AuthRepositoryImpl(remoteAuth: diInstance(), localAuth: diInstance()));

  //remote data source
  diInstance.registerLazySingleton<RemoteAuthSource>(() => FireAuth());

  //local data source
  diInstance.registerLazySingleton<LocalAuthSource>(() => AuthUserHive());

  return diInstance;
}

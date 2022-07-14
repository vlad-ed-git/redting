import 'package:get_it/get_it.dart';
import 'package:redting/features/auth/data/data_sources/local/auth_user_hive.dart';
import 'package:redting/features/auth/data/data_sources/local/local_auth.dart';
import 'package:redting/features/auth/data/data_sources/remote/fire_auth.dart';
import 'package:redting/features/auth/data/data_sources/remote/remote_auth.dart';
import 'package:redting/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:redting/features/auth/domain/repositories/auth_repository.dart';
import 'package:redting/features/auth/domain/use_cases/auth_use_cases.dart';
import 'package:redting/features/auth/domain/use_cases/get_auth_user.dart';
import 'package:redting/features/auth/presentation/state/auth_user_bloc.dart';

/// FACTORY - instantiated every time we request
///  SINGLETON - only a single instance is created

final GetIt authDiInstance = GetIt.instance;
void init() {
  //auth bloc
  authDiInstance
      .registerFactory(() => AuthUserBloc(authUseCases: authDiInstance()));

  //auth useCases
  authDiInstance.registerLazySingleton(
      () => AuthUseCases(getAuthenticatedUser: authDiInstance()));

  //get auth use case
  authDiInstance.registerLazySingleton(
      () => GetAuthenticatedUserCase(repository: authDiInstance()));

  //auth repository
  authDiInstance.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
      remoteAuth: authDiInstance(), localAuth: authDiInstance()));

  //remote data source
  authDiInstance.registerLazySingleton<RemoteAuthSource>(() => FireAuth());

  //local data source
  authDiInstance.registerLazySingleton<LocalAuthSource>(() => AuthUserHive());
}

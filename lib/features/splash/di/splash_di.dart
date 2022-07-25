import 'package:get_it/get_it.dart';
import 'package:redting/features/splash/domain/splash_repository.dart';
import 'package:redting/features/splash/state/current_user_bloc.dart';
import 'package:redting/features/splash/usecases/fetch_current_user.dart';

void init(GetIt authDiInstance, GetIt profileDiInstance,
    GetIt datingProfileDiInstance) {
  final GetIt splashDiInstance = GetIt.instance;
  //auth bloc
  splashDiInstance.registerFactory<CurrentUserBloc>(
      () => CurrentUserBloc(splashDiInstance()));

  //useCases
  splashDiInstance.registerLazySingleton<FetchCurrentUserUseCase>(
      () => FetchCurrentUserUseCase(splashDiInstance()));

  splashDiInstance.registerLazySingleton<SplashRepository>(() =>
      SplashRepository(
          authDiInstance(), profileDiInstance(), datingProfileDiInstance()));
}
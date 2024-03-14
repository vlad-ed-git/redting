import 'package:get_it/get_it.dart';
import 'package:redting/features/splash/domain/splash_repository.dart';
import 'package:redting/features/splash/domain/usecases/fetch_current_user.dart';
import 'package:redting/features/splash/presentation/state/current_user_bloc.dart';

void init() {
  final GetIt diInstance = GetIt.instance;
  //auth bloc
  diInstance
      .registerFactory<CurrentUserBloc>(() => CurrentUserBloc(diInstance()));

  //useCases
  diInstance.registerLazySingleton<FetchCurrentUserUseCase>(
      () => FetchCurrentUserUseCase(diInstance()));

  diInstance.registerLazySingleton<SplashRepository>(
      () => SplashRepository(diInstance(), diInstance()));
}

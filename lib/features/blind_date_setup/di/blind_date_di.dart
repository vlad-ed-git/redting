import 'package:get_it/get_it.dart';
import 'package:redting/features/blind_date_setup/data/data_sources/local/hive_source.dart';
import 'package:redting/features/blind_date_setup/data/data_sources/local/local_source.dart';
import 'package:redting/features/blind_date_setup/data/data_sources/remote/fire_blind_date.dart';
import 'package:redting/features/blind_date_setup/data/data_sources/remote/remote_source.dart';
import 'package:redting/features/blind_date_setup/data/repository/blind_date_repo_impl.dart';
import 'package:redting/features/blind_date_setup/domain/repository/blind_date_repo.dart';
import 'package:redting/features/blind_date_setup/domain/usecases/fetch/fetch_blind_dates_usecases.dart';
import 'package:redting/features/blind_date_setup/domain/usecases/fetch/listen_to_blind_dates_stream.dart';
import 'package:redting/features/blind_date_setup/domain/usecases/fetch/load_old_blind_dates.dart';
import 'package:redting/features/blind_date_setup/domain/usecases/get_user.dart';
import 'package:redting/features/blind_date_setup/domain/usecases/setup/blind_date_usecases.dart';
import 'package:redting/features/blind_date_setup/domain/usecases/setup/check_if_can_setup_blind_date.dart';
import 'package:redting/features/blind_date_setup/domain/usecases/setup/get_icebreakers.dart';
import 'package:redting/features/blind_date_setup/domain/usecases/setup/setup_blind_date.dart';
import 'package:redting/features/blind_date_setup/presentation/pages/state/fetch/load_blind_dates_bloc.dart';
import 'package:redting/features/blind_date_setup/presentation/pages/state/setup/blind_date_bloc.dart';

init() {
  GetIt diInstance = GetIt.instance;
  diInstance.registerFactory<BlindDateBloc>(() => BlindDateBloc(diInstance()));
  diInstance.registerFactory<LoadBlindDatesBloc>(
      () => LoadBlindDatesBloc(diInstance()));

  /// use cases
  diInstance.registerLazySingleton<BlindDateUseCases>(() => BlindDateUseCases(
      diInstance(), diInstance(), diInstance(), diInstance()));
  diInstance.registerLazySingleton<FetchBlindDatesUseCases>(
      () => FetchBlindDatesUseCases(diInstance(), diInstance(), diInstance()));

  diInstance.registerLazySingleton<CheckIfCanSetupBlindDateUseCase>(
      () => CheckIfCanSetupBlindDateUseCase(diInstance()));
  diInstance.registerLazySingleton<GetAuthUserUseCase>(
      () => GetAuthUserUseCase(diInstance()));
  diInstance.registerLazySingleton<SetupBlindDateUseCase>(
      () => SetupBlindDateUseCase(diInstance()));
  diInstance.registerLazySingleton<GetIceBreakersUseCase>(
      () => GetIceBreakersUseCase(diInstance()));
  diInstance.registerLazySingleton<GetBlindDatesStreamUseCase>(
      () => GetBlindDatesStreamUseCase(diInstance()));
  diInstance.registerLazySingleton<LoadOlderBlindDatesUseCase>(
      () => LoadOlderBlindDatesUseCase(diInstance()));

  /// repo
  diInstance.registerLazySingleton<BlindDateRepo>(() => BlindDateRepoImpl(
      diInstance(), diInstance(), diInstance(), diInstance()));

  // data sources
  diInstance
      .registerLazySingleton<LocalBlindDateSource>(() => HiveBlindDateSource());

  diInstance
      .registerLazySingleton<RemoteBlindDateSetupSource>(() => FireBlindDate());
}

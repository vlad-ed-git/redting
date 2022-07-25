import 'package:get_it/get_it.dart';
import 'package:redting/features/dating_profile/data/data_sources/local/hive_dating_profile.dart';
import 'package:redting/features/dating_profile/data/data_sources/local/local_dating_profile_source.dart';
import 'package:redting/features/dating_profile/data/data_sources/remote/fire_dating_profile.dart';
import 'package:redting/features/dating_profile/data/data_sources/remote/remote_dating_profile_source.dart';
import 'package:redting/features/dating_profile/data/repository/dating_profile_repo_impl.dart';
import 'package:redting/features/dating_profile/domain/repository/dating_profile_repo.dart';
import 'package:redting/features/dating_profile/domain/use_cases/crud/create_dating_profile.dart';
import 'package:redting/features/dating_profile/domain/use_cases/crud/get_dating_profile.dart';
import 'package:redting/features/dating_profile/domain/use_cases/crud/update_dating_profile.dart';
import 'package:redting/features/dating_profile/domain/use_cases/dating_profile_usecases.dart';
import 'package:redting/features/dating_profile/domain/use_cases/photos/add_photo_usecase.dart';
import 'package:redting/features/dating_profile/presentation/state/dating_profile_bloc.dart';

/// FACTORY - instantiated every time we request
///  SINGLETON - only a single instance is created

GetIt init() {
  final GetIt datingProfileInstance = GetIt.instance;
  //auth bloc
  datingProfileInstance.registerFactory<DatingProfileBloc>(
      () => DatingProfileBloc(datingProfileInstance()));

  //useCases
  datingProfileInstance
      .registerLazySingleton<DatingProfileUseCases>(() => DatingProfileUseCases(
            getDatingProfileUseCase: datingProfileInstance(),
            createDatingProfileUseCase: datingProfileInstance(),
            updateDatingProfileUseCase: datingProfileInstance(),
            addPhotoUseCase: datingProfileInstance(),
          ));

  datingProfileInstance.registerLazySingleton<GetDatingProfilesUseCase>(
      () => GetDatingProfilesUseCase(datingProfileInstance()));

  datingProfileInstance.registerLazySingleton<CreateDatingProfileUseCase>(
      () => CreateDatingProfileUseCase(datingProfileInstance()));

  datingProfileInstance.registerLazySingleton<UpdateDatingProfileUseCase>(
      () => UpdateDatingProfileUseCase(datingProfileInstance()));

  datingProfileInstance.registerLazySingleton<AddPhotoUseCase>(
      () => AddPhotoUseCase(datingProfileInstance()));

  //repository
  datingProfileInstance
      .registerLazySingleton<DatingProfileRepo>(() => DatingProfileRepoImpl(
            datingProfileInstance(),
            datingProfileInstance(),
            datingProfileInstance(),
          ));

  //remote data source
  datingProfileInstance.registerLazySingleton<RemoteDatingProfileSource>(
      () => FireDatingProfile());

  //local data source
  datingProfileInstance.registerLazySingleton<LocalDatingProfileSource>(
      () => HiveDatingProfile());

  return datingProfileInstance;
}

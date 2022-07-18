import 'package:get_it/get_it.dart';
import 'package:redting/features/profile/data/data_sources/local/hive_profile.dart';
import 'package:redting/features/profile/data/data_sources/local/local_profile_source.dart';
import 'package:redting/features/profile/data/data_sources/remote/fire_profile.dart';
import 'package:redting/features/profile/data/data_sources/remote/remote_profile_source.dart';
import 'package:redting/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:redting/features/profile/domain/repositories/ProfileRepository.dart';
import 'package:redting/features/profile/domain/use_cases/create_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/delete_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/generate_verification_video_code_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/get_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile_usecases.dart';
import 'package:redting/features/profile/domain/use_cases/update_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/upload_profile_photo_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/upload_verification_video_usecase.dart';
import 'package:redting/features/profile/presentation/state/user_profile_bloc.dart';

/// FACTORY - instantiated every time we request
///  SINGLETON - only a single instance is created

void init() {
  final GetIt profileDiInstance = GetIt.instance;
  //auth bloc
  profileDiInstance.registerFactory<UserProfileBloc>(
      () => UserProfileBloc(profileUseCases: profileDiInstance()));

  //useCases
  profileDiInstance.registerLazySingleton<ProfileUseCases>(() =>
      ProfileUseCases(
          updateProfileUseCase: profileDiInstance(),
          deleteProfileUseCase: profileDiInstance(),
          createProfileUseCase: profileDiInstance(),
          getProfileUseCase: profileDiInstance(),
          uploadProfilePhotoUseCase: profileDiInstance(),
          generateVideoVerificationCodeUseCase: profileDiInstance(),
          uploadVerificationVideoUseCase: profileDiInstance()));

  profileDiInstance.registerLazySingleton<GetProfileUseCase>(
      () => GetProfileUseCase(profileRepository: profileDiInstance()));

  profileDiInstance.registerLazySingleton<CreateProfileUseCase>(
      () => CreateProfileUseCase(profileRepository: profileDiInstance()));

  profileDiInstance.registerLazySingleton<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(profileRepository: profileDiInstance()));

  profileDiInstance.registerLazySingleton<DeleteProfileUseCase>(
      () => DeleteProfileUseCase(profileRepository: profileDiInstance()));

  profileDiInstance.registerLazySingleton<UploadProfilePhotoUseCase>(
      () => UploadProfilePhotoUseCase(profileRepository: profileDiInstance()));

  profileDiInstance.registerLazySingleton<GenerateVideoVerificationCodeUseCase>(
      () => GenerateVideoVerificationCodeUseCase(
          profileRepository: profileDiInstance()));

  profileDiInstance.registerLazySingleton<UploadVerificationVideoUseCase>(() =>
      UploadVerificationVideoUseCase(profileRepository: profileDiInstance()));

  //auth repository
  profileDiInstance.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(profileDiInstance(), profileDiInstance()));

  //remote data source
  profileDiInstance
      .registerLazySingleton<RemoteProfileDataSource>(() => FireProfile());

  //local data source
  profileDiInstance
      .registerLazySingleton<LocalProfileDataSource>(() => UserProfileHive());
}

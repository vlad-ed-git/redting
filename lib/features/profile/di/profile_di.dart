import 'package:get_it/get_it.dart';
import 'package:redting/features/profile/data/data_sources/local/hive_profile.dart';
import 'package:redting/features/profile/data/data_sources/local/local_profile_source.dart';
import 'package:redting/features/profile/data/data_sources/remote/fire_profile.dart';
import 'package:redting/features/profile/data/data_sources/remote/remote_profile_source.dart';
import 'package:redting/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:redting/features/profile/domain/repositories/ProfileRepository.dart';
import 'package:redting/features/profile/domain/use_cases/profile/create_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile/get_cached_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile/get_profile_from_remote_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile_photo/upload_profile_photo_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile_usecases.dart';
import 'package:redting/features/profile/domain/use_cases/verification_video/delete_verification_video_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/verification_video/generate_verification_video_code_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/verification_video/upload_verification_video_usecase.dart';
import 'package:redting/features/profile/presentation/state/user_profile_bloc.dart';

/// FACTORY - instantiated every time we request
///  SINGLETON - only a single instance is created

GetIt init(GetIt coreDiInstance) {
  final GetIt profileDiInstance = GetIt.instance;
  //auth bloc
  profileDiInstance.registerFactory<UserProfileBloc>(
      () => UserProfileBloc(profileUseCases: profileDiInstance()));

  //useCases
  profileDiInstance.registerLazySingleton<ProfileUseCases>(() =>
      ProfileUseCases(
          createProfileUseCase: profileDiInstance(),
          getProfileFromRemoteUseCase: profileDiInstance(),
          uploadProfilePhotoUseCase: profileDiInstance(),
          generateVideoVerificationCodeUseCase: profileDiInstance(),
          uploadVerificationVideoUseCase: profileDiInstance(),
          deleteVerificationVideoUseCase: profileDiInstance(),
          getCachedProfileUseCase: profileDiInstance()));

  profileDiInstance.registerLazySingleton<GetProfileFromRemoteUseCase>(() =>
      GetProfileFromRemoteUseCase(profileRepository: profileDiInstance()));

  profileDiInstance.registerLazySingleton<CreateProfileUseCase>(
      () => CreateProfileUseCase(profileRepository: profileDiInstance()));

  profileDiInstance.registerLazySingleton<UploadProfilePhotoUseCase>(
      () => UploadProfilePhotoUseCase(profileRepository: profileDiInstance()));

  profileDiInstance.registerLazySingleton<GenerateVideoVerificationCodeUseCase>(
      () => GenerateVideoVerificationCodeUseCase(
          profileRepository: profileDiInstance()));

  profileDiInstance.registerLazySingleton<GetCachedProfileUseCase>(
      () => GetCachedProfileUseCase(profileRepository: profileDiInstance()));

  profileDiInstance.registerLazySingleton<UploadVerificationVideoUseCase>(() =>
      UploadVerificationVideoUseCase(profileRepository: profileDiInstance()));

  profileDiInstance.registerLazySingleton<DeleteVerificationVideoUseCase>(
      () => DeleteVerificationVideoUseCase(profileDiInstance()));

  //repository
  profileDiInstance
      .registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(
            remoteProfileDataSource: profileDiInstance(),
            imageCompressor: coreDiInstance(),
            localProfileDataSource: profileDiInstance(),
            videoCompressor: coreDiInstance(),
          ));

  //remote data source
  profileDiInstance
      .registerLazySingleton<RemoteProfileDataSource>(() => FireProfile());

  //local data source
  profileDiInstance
      .registerLazySingleton<LocalProfileDataSource>(() => UserProfileHive());

  return profileDiInstance;
}

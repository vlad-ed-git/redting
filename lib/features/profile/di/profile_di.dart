import 'package:get_it/get_it.dart';
import 'package:redting/features/profile/data/data_sources/local/hive_profile.dart';
import 'package:redting/features/profile/data/data_sources/local/local_profile_source.dart';
import 'package:redting/features/profile/data/data_sources/remote/fire_profile.dart';
import 'package:redting/features/profile/data/data_sources/remote/remote_profile_source.dart';
import 'package:redting/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:redting/features/profile/domain/repositories/profile_repository.dart';
import 'package:redting/features/profile/domain/use_cases/profile/create_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile/get_cached_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile/get_profile_from_remote_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile/set_dating_info_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile/update_user_profile_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile_photo/add_dating_pic.dart';
import 'package:redting/features/profile/domain/use_cases/profile_photo/upload_profile_photo_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/profile_usecases.dart';
import 'package:redting/features/profile/domain/use_cases/verification_video/delete_verification_video_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/verification_video/generate_verification_video_code_usecase.dart';
import 'package:redting/features/profile/domain/use_cases/verification_video/upload_verification_video_usecase.dart';
import 'package:redting/features/profile/presentation/state/user_profile_bloc.dart';

/// FACTORY - instantiated every time we request
///  SINGLETON - only a single instance is created

GetIt init() {
  final GetIt diInstance = GetIt.instance;
  //auth bloc
  diInstance.registerFactory<UserProfileBloc>(
      () => UserProfileBloc(profileUseCases: diInstance()));

  //useCases
  diInstance.registerLazySingleton<ProfileUseCases>(() => ProfileUseCases(
      createProfileUseCase: diInstance(),
      getProfileFromRemoteUseCase: diInstance(),
      uploadProfilePhotoUseCase: diInstance(),
      generateVideoVerificationCodeUseCase: diInstance(),
      uploadVerificationVideoUseCase: diInstance(),
      deleteVerificationVideoUseCase: diInstance(),
      getCachedProfileUseCase: diInstance(),
      setDatingInfoUseCase: diInstance(),
      addDatingPicUseCase: diInstance(),
      updateUserProfileUseCase: diInstance()));

  diInstance.registerLazySingleton<GetProfileFromRemoteUseCase>(
      () => GetProfileFromRemoteUseCase(profileRepository: diInstance()));

  diInstance.registerLazySingleton<CreateProfileUseCase>(
      () => CreateProfileUseCase(profileRepository: diInstance()));

  diInstance.registerLazySingleton<UploadProfilePhotoUseCase>(
      () => UploadProfilePhotoUseCase(profileRepository: diInstance()));

  diInstance.registerLazySingleton<GenerateVideoVerificationCodeUseCase>(() =>
      GenerateVideoVerificationCodeUseCase(profileRepository: diInstance()));

  diInstance.registerLazySingleton<GetCachedProfileUseCase>(
      () => GetCachedProfileUseCase(profileRepository: diInstance()));

  diInstance.registerLazySingleton<UploadVerificationVideoUseCase>(
      () => UploadVerificationVideoUseCase(profileRepository: diInstance()));

  diInstance.registerLazySingleton<DeleteVerificationVideoUseCase>(
      () => DeleteVerificationVideoUseCase(diInstance()));

  diInstance.registerLazySingleton<UpdateUserProfileUseCase>(
      () => UpdateUserProfileUseCase(diInstance()));

  diInstance.registerLazySingleton<SetDatingInfoUseCase>(
      () => SetDatingInfoUseCase(diInstance()));
  diInstance.registerLazySingleton<AddDatingPicUseCase>(
      () => AddDatingPicUseCase(diInstance()));

  //repository
  diInstance
      .registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(
            remoteProfileDataSource: diInstance(),
            imageCompressor: diInstance(),
            localProfileDataSource: diInstance(),
            videoCompressor: diInstance(),
          ));

  //remote data source
  diInstance
      .registerLazySingleton<RemoteProfileDataSource>(() => FireProfile());

  //local data source
  diInstance
      .registerLazySingleton<LocalProfileDataSource>(() => UserProfileHive());

  return diInstance;
}

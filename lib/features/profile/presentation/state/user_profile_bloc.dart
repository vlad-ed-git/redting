import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';
import 'package:redting/features/profile/domain/use_cases/profile_usecases.dart';
import 'package:redting/features/profile/domain/utils/dating_pic.dart';
import 'package:redting/res/strings.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final ProfileUseCases profileUseCases;

  UserProfileBloc({required this.profileUseCases})
      : super(UserProfileInitialState()) {
    on<LoadUserProfileFromRemoteEvent>(_onLoadUserProfileFromRemoteEvent);
    on<ChangeProfilePhotoEvent>(_onChangeProfilePhotoEvent);
    on<ChangeVerificationVideoEvent>(_onChangeVerificationVideoEvent);
    on<GetVerificationVideoCodeEvent>(_onGetVerificationVideoCodeEvent);
    on<DeleteVerificationVideoEvent>(_onDeleteVerificationVideoEvent);
    on<CreateUserProfileEvent>(_onCreateUserProfileEvent);
    on<LoadCachedProfileEvent>(_onLoadCachedProfileFromRemoteEvent);
    on<SetDatingInfoEvent>(_onSetDatingInfoEvent);
    on<UpdateUserProfileEvent>(_onUpdatingUserProfileEvent);
  }

  FutureOr<void> _onLoadUserProfileFromRemoteEvent(
      LoadUserProfileFromRemoteEvent event,
      Emitter<UserProfileState> emit) async {
    emit(LoadingUserProfileState());
    OperationResult result =
        await profileUseCases.getProfileFromRemoteUseCase.execute();
    if (result.errorOccurred) {
      emit(ErrorLoadingUserProfileState(
          errMsg: result.errorMessage ?? getProfileError));
    }

    if (result.data is UserProfile) {
      emit(LoadedUserProfileState(profile: result.data as UserProfile));
    }
  }

  FutureOr<void> _onLoadCachedProfileFromRemoteEvent(
      LoadCachedProfileEvent event, Emitter<UserProfileState> emit) async {
    emit(LoadingUserProfileState());
    UserProfile? profile =
        await profileUseCases.getCachedProfileUseCase.execute();
    if (profile == null) {
      emit(ErrorLoadingUserProfileState(errMsg: getProfileError));
    } else {
      emit(LoadedUserProfileState(profile: profile));
    }
  }

  FutureOr<void> _onChangeProfilePhotoEvent(
      ChangeProfilePhotoEvent event, Emitter<UserProfileState> emit) async {
    emit(UpdatingProfilePhotoState(event.photoFile));
    OperationResult result = await profileUseCases.uploadProfilePhotoUseCase
        .execute(file: event.photoFile, filename: event.filename);

    if (result.errorOccurred) {
      emit(UpdatingProfilePhotoFailedState(
          result.errorMessage ?? uploadingPhotoErr));
    } else {
      emit(UpdatedProfilePhotoState(result.data as String));
    }
  }

  FutureOr<void> _onGetVerificationVideoCodeEvent(
      GetVerificationVideoCodeEvent event,
      Emitter<UserProfileState> emit) async {
    emit(LoadingVerificationVideoCodeState());

    OperationResult result =
        await profileUseCases.generateVideoVerificationCodeUseCase.execute();

    if (result.errorOccurred) {
      emit(LoadingVerificationVideoCodeFailedState(result.errorMessage ?? ""));
    } else {
      emit(LoadedVerificationVideoCodeState(result.data));
    }
  }

  FutureOr<void> _onChangeVerificationVideoEvent(
      ChangeVerificationVideoEvent event,
      Emitter<UserProfileState> emit) async {
    emit(UpdatingVerificationVideoState(event.videoFile));

    OperationResult result =
        await profileUseCases.uploadVerificationVideoUseCase.execute(
            file: event.videoFile, verificationCode: event.verificationCode);
    if (result.errorOccurred) {
      emit(UpdatingVerificationVideoFailedState(
          result.errorMessage ?? errorUploadingVerificationVideo));
    } else {
      emit(UpdatedVerificationVideoState(result.data as UserVerificationVideo));
    }
  }

  FutureOr<void> _onDeleteVerificationVideoEvent(
      DeleteVerificationVideoEvent event,
      Emitter<UserProfileState> emit) async {
    emit(DeletingVerificationVideoState());
    OperationResult result =
        await profileUseCases.deleteVerificationVideoUseCase.execute();

    if (result.errorOccurred) {
      emit(DeletingVerificationVideoFailedState(
          result.errorMessage ?? deletingVerificationVideoFailed));
    } else {
      emit(DeletedVerificationVideoState());
    }
  }

  FutureOr<void> _onCreateUserProfileEvent(
      CreateUserProfileEvent event, Emitter<UserProfileState> emit) async {
    emit(CreatingUserProfileState());

    OperationResult result = await profileUseCases.createProfileUseCase.execute(
        name: event.name,
        userId: event.userId,
        profilePhotoUrl: event.profilePhotoUrl,
        gender: event.gender,
        genderOther: event.genderOther,
        bio: event.bio,
        title: event.title,
        birthDay: event.birthDay,
        registerCountry: event.registerCountry,
        verificationVideo: event.verificationVideo);

    if (result.errorOccurred) {
      emit(ErrorCreatingUserProfileState(errMsg: result.errorMessage));
    } else {
      emit(CreatedUserProfileState(profile: result.data as UserProfile));
    }
  }

  FutureOr<void> _onSetDatingInfoEvent(
      SetDatingInfoEvent event, Emitter<UserProfileState> emit) async {
    emit(SettingDatingInfoState());

    OperationResult result = await profileUseCases.setDatingInfoUseCase.execute(
        event.profile,
        event.datingPics,
        event.minAgePreference,
        event.maxAgePreference,
        event.genderPreference,
        event.userOrientation,
        event.makeMyOrientationPublic,
        event.onlyShowMeOthersOfSameOrientation);

    if (result.data is! UserProfile) {
      emit(SettingDatingInfoFailedState(
          result.errorMessage ?? setDatingInfoErr));
    } else {
      emit(SetDatingInfoState(result.data as UserProfile));
    }
  }

  FutureOr<void> _onUpdatingUserProfileEvent(
      UpdateUserProfileEvent event, Emitter<UserProfileState> emit) async {
    emit(UpdatingUserProfileState());

    OperationResult result = await profileUseCases.updateUserProfileUseCase
        .execute(
            profile: event.profile,
            name: event.name,
            profilePhotoUrl: event.profilePhotoUrl,
            genderOther: event.genderOther,
            gender: event.gender,
            bio: event.bio,
            title: event.title,
            birthDay: event.birthDay,
            registerCountry: event.registerCountry);

    if (result.errorOccurred || result.data is! UserProfile) {
      emit(ErrorUpdatingUserProfileState(
          result.errorMessage ?? updateProfileError));
    } else {
      emit(UpdatedUserProfileState(result.data as UserProfile));
    }
  }
}

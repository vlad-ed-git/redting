import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';
import 'package:redting/features/profile/domain/use_cases/profile_usecases.dart';
import 'package:redting/res/strings.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final ProfileUseCases profileUseCases;

  UserProfileBloc({required this.profileUseCases})
      : super(UserProfileInitialState()) {
    on<LoadUserProfileEvent>(_onLoadUserProfileEvent);
    on<ChangeProfilePhotoEvent>(_onChangeProfilePhotoEvent);
    on<ChangeVerificationVideoEvent>(_onChangeVerificationVideoEvent);
    on<GetVerificationVideoCodeEvent>(_onGetVerificationVideoCodeEvent);
    on<DeleteVerificationVideoEvent>(_onDeleteVerificationVideoEvent);
  }

  FutureOr<void> _onLoadUserProfileEvent(
      LoadUserProfileEvent event, Emitter<UserProfileState> emit) async {
    ///TODO fetch user
    emit(LoadingUserProfileState());
  }

  FutureOr<void> _onChangeProfilePhotoEvent(
      ChangeProfilePhotoEvent event, Emitter<UserProfileState> emit) async {
    emit(UpdatingProfilePhotoState(event.photoFile));
    OperationResult result = await profileUseCases.uploadProfilePhotoUseCase
        .execute(file: event.photoFile, filename: event.filename);

    if (result.errorOccurred) {
      emit(UpdatingProfilePhotoFailedState(result.errorMessage!));
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
      emit(LoadingVerificationVideoCodeFailedState(result.errorMessage!));
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
      emit(UpdatingVerificationVideoFailedState(result.errorMessage!));
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
}

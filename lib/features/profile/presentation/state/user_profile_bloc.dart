import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/use_cases/profile_usecases.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final ProfileUseCases profileUseCases;

  UserProfileBloc({required this.profileUseCases})
      : super(UserProfileInitialState()) {
    on<LoadUserProfileEvent>(_onLoadUserProfileEvent);
    on<ChangeProfilePhotoEvent>(_onChangeProfilePhotoEvent);
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
        .execute(file: event.photoFile);

    if (result.errorOccurred) {
      emit(UpdatingProfilePhotoFailedState(result.errorMessage!));
    } else {
      emit(UpdatedProfilePhotoState(result.data as String));
    }
  }
}
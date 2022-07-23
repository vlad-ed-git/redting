import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/dating_profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/dating_profile/domain/use_cases/dating_profile_usecases.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/res/strings.dart';

part 'dating_profile_event.dart';
part 'dating_profile_state.dart';

class DatingProfileBloc extends Bloc<DatingProfileEvent, DatingProfileState> {
  final DatingProfileUseCases datingProfileUseCase;

  DatingProfileBloc(this.datingProfileUseCase)
      : super(DatingProfileInitialState()) {
    on<LoadDatingProfileEvent>(_onLoadDatingProfileEvent);
    on<CreateProfileEvent>(_onCreateProfileEvent);
  }

  FutureOr<void> _onLoadDatingProfileEvent(
      LoadDatingProfileEvent event, Emitter<DatingProfileState> emit) async {
    emit(LoadingDatingProfileState());

    OperationResult result = await datingProfileUseCase.getDatingProfileUseCase
        .execute(event.userId);

    if (result.errorOccurred) {
      emit(LoadingDatingProfileFailedState(
          result.errorMessage ?? getDatingProfileErr));
    } else {
      if (result.data is DatingProfile) {
        emit(LoadedDatingProfileState(result.data as DatingProfile));
      }

      if (result.data == null) {
        emit(NoDatingProfileState());
      }
    }
  }

  FutureOr<void> _onCreateProfileEvent(
      CreateProfileEvent event, Emitter<DatingProfileState> emit) async {
    emit(CreatingProfileState());

    OperationResult result =
        await datingProfileUseCase.createDatingProfileUseCase.execute(
            event.userId,
            event.photoFiles,
            event.datingPicsFileNames,
            event.minAgePreference,
            event.maxAgePreference,
            event.genderPreference,
            event.userOrientation,
            event.makeMyOrientationPublic,
            event.onlyShowMeOthersOfSameOrientation);

    if (result.data is! DatingProfile) {
      emit(CreatingProfileFailedState(
          result.errorMessage ?? createDatingProfileErr));
    } else {
      emit(CreatedProfileState(result.data as DatingProfile));
    }
  }
}

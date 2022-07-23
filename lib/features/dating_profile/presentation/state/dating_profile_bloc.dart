import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/dating_profile/domain/use_cases/dating_profile_usecases.dart';
import 'package:redting/res/strings.dart';

part 'dating_profile_event.dart';
part 'dating_profile_state.dart';

class DatingProfileBloc extends Bloc<DatingProfileEvent, DatingProfileState> {
  final DatingProfileUseCases datingProfileUseCase;

  DatingProfileBloc(this.datingProfileUseCase)
      : super(DatingProfileInitialState()) {
    on<LoadDatingProfileEvent>(_onLoadDatingProfileEvent);
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
}

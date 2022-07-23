import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/splash/domain/current_user_status_util.dart';
import 'package:redting/features/splash/usecases/fetch_current_user.dart';
import 'package:redting/res/strings.dart';

part 'current_user_event.dart';
part 'current_user_state.dart';

class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  final FetchCurrentUserUseCase fetchCurrentUserUseCase;
  CurrentUserBloc(this.fetchCurrentUserUseCase) : super(InitialState()) {
    on<LoadCurrentUserEvent>(_onLoadCurrentUserEvent);
  }

  FutureOr<void> _onLoadCurrentUserEvent(
      LoadCurrentUserEvent event, Emitter<CurrentUserState> emit) async {
    emit(LoadingCurrentUserState());
    CurrentUserStatus status = await fetchCurrentUserUseCase.execute();
    if (status.errorFetchingStatus) {
      emit(ErrorLoadingCurrentUserState(loadingAuthUserErr));
    } else {
      emit(LoadedCurrentUserState(
          status.authUser, status.profile, status.datingProfile));
    }
  }
}

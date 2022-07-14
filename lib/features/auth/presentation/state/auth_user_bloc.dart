import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:redting/core/utils/service_result.dart';

import '../../domain/models/auth_user.dart';
import '../../domain/use_cases/auth_use_cases.dart';

part 'auth_user_event.dart';
part 'auth_user_state.dart';

class AuthUserBloc extends Bloc<AuthUserEvent, AuthUserState> {
  final AuthUseCases authUseCases;
  AuthUserBloc({required this.authUseCases}) : super(InitialAuthUserState()) {
    on<LoadAuthUserEvent>(_onLoadAuthUserEvent);
  }

  _onLoadAuthUserEvent(
      LoadAuthUserEvent event, Emitter<AuthUserState> emit) async {
    //loading
    emit(LoadingAuthUserState());

    OperationResult result = await authUseCases.getAuthenticatedUser.execute();
    if (result.errorOccurred) {
      emit(ErrorLoadingAuthUserState());
    } else if (result.data is AuthUser) {
      emit(LoadedAuthUserState(result.data as AuthUser));
    } else if (result.data == null) {
      emit(NoAuthUserFoundState());
    }
  }
}

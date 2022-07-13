import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/auth/domain/use_cases/get_auth_user.dart';

part 'auth_user_event.dart';
part 'auth_user_state.dart';

class AuthUserBloc extends Bloc<AuthUserEvent, AuthUserState> {
  final GetAuthenticatedUserCase authenticatedUserCase;

  AuthUserBloc({required this.authenticatedUserCase}) : super(InitialState());
}

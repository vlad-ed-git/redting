import 'package:redting/features/auth/domain/use_cases/get_auth_user.dart';

class AuthUseCases {
  final GetAuthenticatedUserCase getAuthenticatedUser;
  AuthUseCases({required this.getAuthenticatedUser});
}

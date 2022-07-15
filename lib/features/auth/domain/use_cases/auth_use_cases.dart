import 'package:redting/features/auth/domain/use_cases/get_auth_user.dart';
import 'package:redting/features/auth/domain/use_cases/send_verification_code.dart';
import 'package:redting/features/auth/domain/use_cases/sign_user_in.dart';

class AuthUseCases {
  final GetAuthenticatedUserCase getAuthenticatedUser;
  final SendVerificationCodeUseCase sendVerificationCodeUseCase;
  final SignUserInUseCase signUserInUseCase;
  AuthUseCases(
      {required this.sendVerificationCodeUseCase,
      required this.getAuthenticatedUser,
      required this.signUserInUseCase});
}

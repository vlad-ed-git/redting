import 'package:redting/features/splash/domain/current_user_status_util.dart';
import 'package:redting/features/splash/domain/splash_repository.dart';

class FetchCurrentUserUseCase {
  final SplashRepository splashRepository;
  FetchCurrentUserUseCase(this.splashRepository);

  Future<CurrentUserStatus> execute() async {
    return await splashRepository.fetchCurrentUserStatus();
  }
}

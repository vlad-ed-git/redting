import 'package:redting/features/auth/presentation/pages/login_screen.dart';
import 'package:redting/features/auth/presentation/pages/splash_screen.dart';

const splashRoute = '/';
const loginRoute = '/login';
var appRoutes = {
  splashRoute: (context) => const SplashScreen(),
  loginRoute: (context) => const LoginScreen()
};

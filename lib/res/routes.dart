import 'package:redting/features/auth/presentation/pages/login_screen.dart';
import 'package:redting/features/auth/presentation/pages/splash_screen.dart';

const loginRoute = '/login';
var appRoutes = {
  '/': (context) => const SplashScreen(),
  loginRoute: (context) => const LoginScreen()
};

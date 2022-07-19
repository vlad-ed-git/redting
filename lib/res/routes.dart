import 'package:redting/features/auth/presentation/pages/login_screen.dart';
import 'package:redting/features/auth/presentation/pages/splash_screen.dart';
import 'package:redting/features/profile/presentation/pages/create_profile_screen.dart';

const splashRoute = '/';
const loginRoute = '/login';
const createProfileRoute = '/createProfile';
const cameraPreviewOnProfile = '/cameraPreview';
var appRoutes = {
  splashRoute: (context) => const SplashScreen(),
  loginRoute: (context) => const LoginScreen(),
  createProfileRoute: (context) => const CreateProfileScreen(),
};

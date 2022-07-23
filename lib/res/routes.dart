import 'package:redting/features/auth/presentation/pages/login_screen.dart';
import 'package:redting/features/dating_profile/presentation/pages/create_dating_profile_screen.dart';
import 'package:redting/features/home/presentation/pages/home_screen.dart';
import 'package:redting/features/profile/presentation/pages/create_profile_screen.dart';
import 'package:redting/features/splash/splash_screen.dart';

const splashRoute = '/';
const loginRoute = '/login';
const createProfileRoute = '/createProfile';
const cameraPreviewOnProfile = '/cameraPreview';
const homeRoute = '/home';
const createDatingProfileRoute = '/createDatingProfile';
var appRoutes = {
  splashRoute: (context) => const SplashScreen(),
  loginRoute: (context) => const LoginScreen(),
  createProfileRoute: (context) => const CreateProfileScreen(),
  homeRoute: (context) => const HomeScreen(),
  createDatingProfileRoute: (context) => const CreateDatingProfileScreen()
};

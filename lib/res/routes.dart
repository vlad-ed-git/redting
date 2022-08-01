import 'package:redting/features/auth/presentation/pages/login_screen.dart';
import 'package:redting/features/home/presentation/pages/home_screen.dart';
import 'package:redting/features/profile/presentation/pages/add_dating_info_screen.dart';
import 'package:redting/features/profile/presentation/pages/create_profile_screen.dart';
import 'package:redting/features/splash/presentation/pages/splash_screen.dart';

const splashRoute = '/';
const loginRoute = '/login';
const createProfileRoute = '/createProfile';
const cameraPreviewOnProfile = '/cameraPreview';
const homeRoute = '/home';
const addDatingProfileRoute = '/addDatingProfile';
var appRoutes = {
  splashRoute: (context) => const SplashScreen(),
  loginRoute: (context) => const LoginScreen(),
  createProfileRoute: (context) => const CreateProfileScreen(),
  homeRoute: (context) => const HomeScreen(),
  addDatingProfileRoute: (context) => const AddDatingInfoScreen()
};

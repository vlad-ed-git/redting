import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/data/local_storage.dart';
import 'package:redting/core/di/core_dependencies.dart' as core_di;
import 'package:redting/features/auth/di/auth_di.dart' as auth_di;
import 'package:redting/features/dating_profile/di/dating_profile_di.dart'
    as dating_profile_di;
import 'package:redting/features/home/di/matching_di.dart' as matching_di;
import 'package:redting/features/profile/di/profile_di.dart' as profile_di;
import 'package:redting/features/splash/di/splash_di.dart' as splash_di;

import 'firebase_options.dart';

class MainAppInit {
  static Future<bool> initApp() async {
    try {
      await _initFirebase();
      bool success = await _initLocalStorage();
      if (success) {
        _initDependencies();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  static Future _initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<bool> _initLocalStorage() async {
    try {
      await LocalStorage.init();
      return true;
    } catch (e) {
      return false;
    }
  }

  static void _initDependencies() {
    try {
      core_di.init();
      GetIt authDiInstance = auth_di.init();
      GetIt profileDiInstance = profile_di.init();
      GetIt datingProfileDiInstance = dating_profile_di.init();
      matching_di.init(profileDiInstance, datingProfileDiInstance);
      splash_di.init(
          authDiInstance, profileDiInstance, datingProfileDiInstance);
    } catch (e) {
      print("===================== $e ============= ");
    }
  }

  static void dispose() {
    LocalStorage.dispose();
  }
}

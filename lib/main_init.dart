import 'package:firebase_core/firebase_core.dart';
import 'package:redting/core/data/local_storage.dart';
import 'package:redting/core/di/core_dependencies.dart' as core_di;
import 'package:redting/features/auth/di/auth_di.dart' as auth_di;
import 'package:redting/features/blind_date_setup/di/blind_date_di.dart'
    as blind_date_di;
import 'package:redting/features/chat/di/chat_di.dart' as chat_di;
import 'package:redting/features/matching/di/matching_di.dart' as matching_di;
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
      auth_di.init();
      profile_di.init();
      matching_di.init();
      chat_di.init();
      splash_di.init();
      blind_date_di.init();
    } catch (e) {
      print("===================== $e ============= ");
    }
  }

  static void dispose() {
    LocalStorage.dispose();
  }
}

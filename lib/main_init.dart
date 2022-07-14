import 'package:firebase_core/firebase_core.dart';
import 'package:redting/core/data/local_storage.dart';
import 'package:redting/features/auth/di/auth_di.dart' as auth_di;

import 'firebase_options.dart';

class MainAppInit {
  static Future initApp() async {
    await _initFirebase();
    bool success = await _initLocalStorage();
    if (success) {
      _initDependencies();
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
    auth_di.init();
  }
}

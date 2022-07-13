import 'package:firebase_core/firebase_core.dart';
import 'package:redting/core/data/local_storage.dart';

import 'firebase_options.dart';

class MainAppInit {
  static void init() {
    _initFirebase();
    _initLocalStorage();
  }

  static void _initFirebase() async {
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
}

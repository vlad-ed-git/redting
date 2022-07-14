import 'package:hive_flutter/hive_flutter.dart';
import 'package:redting/core/data/hive_names.dart';
import 'package:redting/features/auth/data/entities/auth_user_entity.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';

class LocalStorage {
  static Future init() async {
    await Hive.initFlutter();
    _registerAllAdapters();
    await _openAllBoxes();
  }

  static _registerAllAdapters() async {
    _registerAuthUserAdapter();
    //todo other adapters
  }

  static Future _openAllBoxes() async {
    await _openBoxAuthUser();
    //todo other boxes
  }

  static Future dispose() async {
    await Hive.close(); //release all open boxes
  }

  static Future _openBoxAuthUser() {
    return Hive.openBox<AuthUser?>(auth_user_box);
  }

  static void _registerAuthUserAdapter() {
    return Hive.registerAdapter(AuthUserEntityAdapter(), override: true);
  }
}

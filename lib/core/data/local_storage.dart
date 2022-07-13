import 'package:hive_flutter/hive_flutter.dart';
import 'package:redting/core/data/hive_names.dart';
import 'package:redting/features/auth/data/entities/auth_user_entity.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';

class LocalStorage {
  static init() async {
    await Hive.initFlutter();
    await _registerAllAdapters();
    await _openAllBoxes();
  }

  static _registerAllAdapters() async {
    await _registerAuthUserAdapter();
    //todo other adapters
  }

  static _openAllBoxes() async {
    await _openBoxAuthUser();
    //todo other boxes
  }

  static void dispose() async {
    Hive.close(); //release all open boxes
  }

  static _openBoxAuthUser() {
    return Hive.openBox<AuthUser>(auth_user_box);
  }

  static _registerAuthUserAdapter() {
    return Hive.registerAdapter(AuthUserEntityAdapter(), override: true);
  }
}

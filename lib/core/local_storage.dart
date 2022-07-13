import 'package:hive_flutter/hive_flutter.dart';

class CoreLocalStorage {
  static init() async {
    await Hive.initFlutter();
    await _registerAllAdapters();
    await _openAllBoxes();
  }

  static _registerAllAdapters() async {
    //todo await _registerUsersAdapter();
    //todo other adapters
  }

  static _openAllBoxes() async {
    //todo await _openBoxUsers();
    //todo other boxes
  }

  static void dispose() async {
    Hive.close(); //release all open boxes
  }

  //users
  //todo static Box<Users> getUsersBox() => Hive.box<Users>(users_box_name);

  static _openBoxUsers() {
    //todo return Hive.openBox<Users>(users_box_name);
  }

  static _registerUsersAdapter() {
    //todo return Hive.registerAdapter(UsersAdapter(), override: true);
  }
}

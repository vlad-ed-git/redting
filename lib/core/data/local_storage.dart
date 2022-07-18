import 'package:hive_flutter/hive_flutter.dart';
import 'package:redting/core/data/hive_names.dart';
import 'package:redting/features/auth/data/entities/auth_user_entity.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/profile/data/entities/user_profile_entity.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

class LocalStorage {
  static Future init() async {
    await Hive.initFlutter();
    _registerAllAdapters();
    await _openAllBoxes();
  }

  static _registerAllAdapters() async {
    _registerAuthUserAdapter();
    _registerUserProfileAdapter();
    //todo other adapters
  }

  static Future _openAllBoxes() async {
    await _openBoxAuthUser();
    await _openBoxUserProfile();
    //todo other boxes
  }

  static Future dispose() async {
    await Hive.close(); //release all open boxes
  }

  /// auth user
  static Future _openBoxAuthUser() {
    return Hive.openBox<AuthUser?>(authUserBox);
  }

  static void _registerAuthUserAdapter() {
    return Hive.registerAdapter(AuthUserEntityAdapter(), override: true);
  }

  /// user profile
  static Future _openBoxUserProfile() {
    return Hive.openBox<UserProfile?>(userProfileBox);
  }

  static void _registerUserProfileAdapter() {
    return Hive.registerAdapter(UserProfileEntityAdapter(), override: true);
  }
}

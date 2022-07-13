import 'package:hive_flutter/hive_flutter.dart';
import 'package:redting/core/data/hive_names.dart';
import 'package:redting/features/auth/data/data_sources/local/local_auth.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';

class AuthUserHive implements LocalAuth {
  final String _userKey = "auth_user_key";

  @override
  Future<void> cacheAuthUser({required AuthUser authUser}) async {
    final usersHive = _getUserBox();
    await usersHive.put(_userKey, authUser);
  }

  @override
  AuthUser? getAuthUser() {
    return _getUserBox().get(_userKey);
  }

  Box<AuthUser?> _getUserBox() {
    return Hive.box<AuthUser?>(auth_user_box);
  }
}

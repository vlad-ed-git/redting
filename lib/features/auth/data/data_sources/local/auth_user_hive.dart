import 'package:hive_flutter/hive_flutter.dart';
import 'package:redting/core/data/hive_names.dart';
import 'package:redting/features/auth/data/data_sources/local/local_auth.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';

class AuthUserHive implements LocalAuthSource {
  final String _userKey = "auth_user_key";
  final Box _usersHiveBox = Hive.box<AuthUser?>(auth_user_box);

  @override
  Future<void> cacheAuthUser({required AuthUser authUser}) async {
    await _usersHiveBox.put(_userKey, authUser);
  }

  @override
  AuthUser? getAuthUser() {
    return _usersHiveBox.get(_userKey);
  }
}

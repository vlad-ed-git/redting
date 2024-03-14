import 'package:hive_flutter/hive_flutter.dart';
import 'package:redting/core/data/hive_names.dart';
import 'package:redting/features/auth/data/entities/auth_user_entity.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/matching/data/entities/ice_breaker_messages_entity.dart';
import 'package:redting/features/matching/domain/models/ice_breaker_msg.dart';
import 'package:redting/features/profile/data/entities/sexual_orientation_entity.dart';
import 'package:redting/features/profile/data/entities/user_gender_entity.dart';
import 'package:redting/features/profile/data/entities/user_profile_entity.dart';
import 'package:redting/features/profile/data/entities/user_verification_video_entity.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

class LocalStorage {
  static Future init() async {
    await Hive.initFlutter();
    _registerAllAdapters();
    await _openAllBoxes();
  }

  static _registerAllAdapters() async {
    _registerAuthUserAdapter();
    _registerUserProfileAdapters();
    _registerMatchingDataAdapters();
    //todo other adapters
  }

  static Future _openAllBoxes() async {
    await _openBoxAuthUser();
    await _openBoxUserProfile();
    await _openMatchingDataBox();
    await _openCanMakeBlindDatesBox();
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

  static void _registerUserProfileAdapters() {
    Hive.registerAdapter(SexualOrientationEntityAdapter(), override: true);
    Hive.registerAdapter(UserGenderEntityAdapter(), override: true);
    Hive.registerAdapter(UserVerificationVideoEntityAdapter(), override: true);
    Hive.registerAdapter(UserProfileEntityAdapter(), override: true);
  }

  /// Matching Feature Data
  static void _registerMatchingDataAdapters() {
    Hive.registerAdapter(IceBreakerMessagesEntityAdapter(), override: true);
  }

  static Future _openMatchingDataBox() async {
    await Hive.openBox<Map<dynamic, dynamic>?>(likedUsersBox);
    await Hive.openBox<IceBreakerMessages?>(iceBreakersBox);
  }

  /// blind data setup status
  static Future _openCanMakeBlindDatesBox() async {
    await Hive.openBox<bool?>(canMakeBlindDatesBox);
  }
}

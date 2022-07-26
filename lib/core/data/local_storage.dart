import 'package:hive_flutter/hive_flutter.dart';
import 'package:redting/core/data/hive_names.dart';
import 'package:redting/features/auth/data/entities/auth_user_entity.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/dating_profile/data/entities/dating_profile_entity.dart';
import 'package:redting/features/dating_profile/data/entities/sexual_orientation_entity.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/home/data/entity/ice_breaker_messages_entity.dart';
import 'package:redting/features/home/data/entity/like_notification_entity.dart';
import 'package:redting/features/home/domain/models/ice_breaker_msg.dart';
import 'package:redting/features/home/domain/models/like_notification.dart';
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
    _registerDatingProfileAdapters();
    _registerMatchingDataAdapters();
    //todo other adapters
  }

  static Future _openAllBoxes() async {
    await _openBoxAuthUser();
    await _openBoxUserProfile();
    await _openBoxDatingProfile();
    await _openMatchingDataBox();
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
    Hive.registerAdapter(UserGenderEntityAdapter(), override: true);
    Hive.registerAdapter(UserVerificationVideoEntityAdapter(), override: true);
    Hive.registerAdapter(UserProfileEntityAdapter(), override: true);
  }

  /// dating profile
  static void _registerDatingProfileAdapters() {
    Hive.registerAdapter(SexualOrientationEntityAdapter(), override: true);
    Hive.registerAdapter(DatingProfileEntityAdapter(), override: true);
  }

  static Future _openBoxDatingProfile() {
    return Hive.openBox<DatingProfile?>(datingProfileBox);
  }

  /// Matching Feature Data
  static void _registerMatchingDataAdapters() {
    Hive.registerAdapter(IceBreakerMessagesEntityAdapter(), override: true);
    Hive.registerAdapter(LikeNotificationEntityAdapter(), override: true);
  }

  static Future _openMatchingDataBox() async {
    await Hive.openBox<Map<dynamic, dynamic>?>(likedUsersBox);
    await Hive.openBox<IceBreakerMessages?>(iceBreakersBox);
    await Hive.openBox<LikeNotification>(likeNotificationBox);
  }
}

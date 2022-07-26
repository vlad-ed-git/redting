import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:redting/core/data/hive_names.dart';
import 'package:redting/features/home/data/data_sources/local/local_matching_data_source.dart';
import 'package:redting/features/home/domain/models/ice_breaker_msg.dart';

class HiveMatchingDataSource implements LocalMatchingDataSource {
  final Box _iceBreakersHiveBox = Hive.box<IceBreakerMessages?>(iceBreakersBox);
  final Box _likedUsersBox = Hive.box<Map<dynamic, dynamic>?>(likedUsersBox);

  @override
  Future<IceBreakerMessages?> cacheIceBreakersAndGet(
      IceBreakerMessages icebreakers) async {
    try {
      await _iceBreakersHiveBox.put(iceBreakersKey, icebreakers);
      return icebreakers;
    } catch (e) {
      if (kDebugMode) {
        print("============== cacheIceBreakersAndGet local - $e ============");
      }
      return null;
    }
  }

  @override
  IceBreakerMessages? getIceBreakerMessages() {
    return _iceBreakersHiveBox.get(iceBreakersKey);
  }

  @override
  Future cacheLikedUser(String likedUserId) async {
    Map<dynamic, dynamic> likedUsersCache = getLikedUsersCache();
    likedUsersCache[likedUserId] = true;
    await _likedUsersBox.put(likedUsersBoxKey, likedUsersCache);
  }

  @override
  Map<dynamic, dynamic> getLikedUsersCache() {
    return _likedUsersBox.get(likedUsersBoxKey, defaultValue: {});
  }
}

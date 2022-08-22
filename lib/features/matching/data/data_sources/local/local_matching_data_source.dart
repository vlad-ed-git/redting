import 'package:redting/features/matching/domain/models/ice_breaker_msg.dart';

abstract class LocalMatchingDataSource {
  Future<IceBreakerMessages?> getIceBreakerMessages();
  Future<IceBreakerMessages?> cacheIceBreakersAndGet(
      IceBreakerMessages icebreakers);
  Future cacheLikedUser(String likedUserId);
  Map<dynamic, dynamic> getLikedUsersCache();
}

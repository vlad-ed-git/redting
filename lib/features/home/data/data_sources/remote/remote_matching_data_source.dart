import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/home/domain/models/ice_breaker_msg.dart';
import 'package:redting/features/home/domain/models/like_notification.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

abstract class RemoteMatchingDataSource {
  Future<OperationResult> likeUser(LikeNotification likeNotification);
  Future<IceBreakerMessages?> getIceBreakerMessages();
  Future<OperationResult> getDatingProfiles(
      UserProfile thisUsersProfile, DatingProfile thisUsersDatingProfile);
}

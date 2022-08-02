import 'package:flutter/foundation.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/core/utils/txt_helpers.dart';
import 'package:redting/features/matching/data/data_sources/local/local_matching_data_source.dart';
import 'package:redting/features/matching/data/data_sources/remote/remote_matching_data_source.dart';
import 'package:redting/features/matching/data/entities/daily_user_feedback_entity.dart';
import 'package:redting/features/matching/data/entities/liked_user_entity.dart';
import 'package:redting/features/matching/data/entities/matching_profiles_entity.dart';
import 'package:redting/features/matching/domain/models/ice_breaker_msg.dart';
import 'package:redting/features/matching/domain/models/liked_user.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';
import 'package:redting/features/matching/domain/repositories/matching_repository.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/repositories/profile_repository.dart';
import 'package:redting/res/strings.dart';

class MatchingRepositoryImpl implements MatchingRepository {
  final ProfileRepository _profileRepository;
  final LocalMatchingDataSource localDataSource;
  final RemoteMatchingDataSource remoteDataSource;
  final List<String> icebreakersCacheMessages = [];
  MatchingRepositoryImpl(
      this._profileRepository, this.localDataSource, this.remoteDataSource);

  @override
  Future<OperationResult> getProfilesToMatchWith(
      UserProfile userProfile) async {
    List<UserProfile>? profilesToMatchOrNull =
        await remoteDataSource.getProfilesToMatchWith(userProfile);
    if (profilesToMatchOrNull == null) {
      return OperationResult(errorOccurred: true);
    }
    //removed liked users
    Map<dynamic, dynamic> likedUsers = localDataSource.getLikedUsersCache();
    profilesToMatchOrNull.removeWhere((e) => likedUsers.containsKey(e.userId));
    return OperationResult(data: profilesToMatchOrNull);
  }

  @override
  Future<OperationResult> getThisUserInfo() async {
    UserProfile? userProfile = await _profileRepository.getCachedUserProfile();
    return OperationResult(
        errorOccurred: userProfile == null,
        errorMessage: userProfile == null ? loadingAuthUserErr : '',
        data: userProfile);
  }

  @override
  Future<OperationResult> likeUser(String thisUserId, String likedUserId,
      String likedUserName, String likedUserProfilePhotoUrl) async {
    try {
      String iceBreaker = await _getRandomIceBreakerMessage();
      if (iceBreaker.isEmpty) {
        return OperationResult(
            errorMessage: likingUserFailed, errorOccurred: true);
      }

      LikedUser likedUser = LikedUserEntity(
          likedByUserId: thisUserId,
          likedOn: DateTime.now(),
          likedUserId: likedUserId);
      MatchingProfiles matchingProfiles = MatchingProfilesEntity(
          userAUserBIdsConcatNSorted:
              MatchingProfiles.concatUser1User2IdsSortAndSetAsId(
                  thisUserId, likedUserId),
          iceBreakers: [iceBreaker],
          likers: [thisUserId],
          otherUser: [
            MatchingMembersEntity(
                likedUserId, likedUserName, likedUserProfilePhotoUrl)
          ],
          updatedOn: DateTime.now()
          //add self
          );

      OperationResult result =
          await remoteDataSource.likeUser(likedUser, matchingProfiles);
      if (!result.errorOccurred) {
        //cache liked user
        await localDataSource.cacheLikedUser(likedUserId);
      }
      return result;
    } catch (e) {
      if (kDebugMode) {
        print("=============== repo likeUser $e ==========");
      }
      return OperationResult(
          errorOccurred: true, errorMessage: likingUserFailed);
    }
  }

  Future<String> _getRandomIceBreakerMessage() async {
    try {
      if (icebreakersCacheMessages.isEmpty) {
        IceBreakerMessages? icebreakers =
            localDataSource.getIceBreakerMessages();
        icebreakersCacheMessages.addAll(icebreakers!.messages);
      }

      return randomWordInList(icebreakersCacheMessages);
    } catch (e) {
      if (kDebugMode) {
        print(
            "=============== repo getRandomIceBreakerMessage() $e ==========");
      }
      return "";
    }
  }

  @override
  Future<bool> loadIceBreakerMessagesToCache() async {
    try {
      IceBreakerMessages? icebreakers =
          await remoteDataSource.getIceBreakerMessages();
      localDataSource.cacheIceBreakersAndGet(icebreakers!);
      icebreakersCacheMessages.clear();
      icebreakersCacheMessages.addAll(icebreakers.messages);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(
            "=============== repo getRandomIceBreakerMessage() $e ==========");
      }
      return false;
    }
  }

  @override
  Future<bool> loadLikedUsersToCache() async {
    try {
      OperationResult result = await remoteDataSource.getUsersILike();
      if (result.data is List) {
        List<LikedUser> users = result.data as List<LikedUser>;
        for (LikedUser user in users) {
          await localDataSource.cacheLikedUser(user.likedUserId);
        }
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("=========== loadLikedUsersToCache exc $e ===========");
      }
      return false;
    }
  }

  @override
  Future<OperationResult> sendDailyFeedback(
      String userId, String feedback, int rating) async {
    return await remoteDataSource.sendDailyFeedback(
        DailyUserFeedbackEntity(feedback, rating, DateTime.now(), userId));
  }

  @override
  Stream<List<OperationRealTimeResult>> listenToMatches() {
    return remoteDataSource.listenToMatches();
  }
}

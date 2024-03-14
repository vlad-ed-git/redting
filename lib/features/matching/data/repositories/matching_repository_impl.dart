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
  final LocalMatchingDataSource _localDataSource;
  final RemoteMatchingDataSource _remoteDataSource;
  final List<String> icebreakersCacheMessages = [];
  MatchingRepositoryImpl(
      this._profileRepository, this._localDataSource, this._remoteDataSource);

  @override
  Future<ServiceResult> getProfilesToMatchWith(UserProfile userProfile) async {
    List<UserProfile>? profilesToMatchOrNull =
        await _remoteDataSource.getProfilesToMatchWith(userProfile);
    if (profilesToMatchOrNull == null) {
      return ServiceResult(errorOccurred: true);
    }
    //removed liked users
    Map<dynamic, dynamic> likedUsers = _localDataSource.getLikedUsersCache();
    profilesToMatchOrNull.removeWhere((e) => likedUsers.containsKey(e.userId));
    return ServiceResult(data: profilesToMatchOrNull);
  }

  @override
  Future<ServiceResult> getThisUserInfo() async {
    UserProfile? userProfile = await _profileRepository.getCachedUserProfile();
    return ServiceResult(
        errorOccurred: userProfile == null,
        errorMessage: userProfile == null ? loadingAuthUserErr : '',
        data: userProfile);
  }

  @override
  Future<ServiceResult> likeUser(String thisUserId, String likedUserId,
      String likedUserName, String likedUserProfilePhotoUrl) async {
    try {
      String iceBreaker = await _getRandomIceBreakerMessage();
      if (iceBreaker.isEmpty) {
        return ServiceResult(
            errorMessage: likingUserFailed, errorOccurred: true);
      }

      LikedUser likedUser = LikedUserEntity(
          likedByUserId: thisUserId,
          likedOn: DateTime.now(),
          likedUserId: likedUserId);
      MatchingProfiles matchingProfiles = MatchingProfilesEntity(
          userAUserBIdsConcatNSorted:
              MatchingProfiles.concatUser1User2IdsSortAndGetAsId(
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

      ServiceResult result =
          await _remoteDataSource.likeUser(likedUser, matchingProfiles);
      if (!result.errorOccurred) {
        //cache liked user
        await _localDataSource.cacheLikedUser(likedUserId);
      }
      return result;
    } catch (e) {
      if (kDebugMode) {
        print("=============== repository likeUser $e ==========");
      }
      return ServiceResult(errorOccurred: true, errorMessage: likingUserFailed);
    }
  }

  Future<String> _getRandomIceBreakerMessage() async {
    try {
      if (icebreakersCacheMessages.isEmpty) {
        IceBreakerMessages? icebreakers =
            await _localDataSource.getIceBreakerMessages();
        icebreakersCacheMessages.addAll(icebreakers!.messages);
      }

      return randomWordInList(icebreakersCacheMessages);
    } catch (e) {
      if (kDebugMode) {
        print(
            "=============== repository getRandomIceBreakerMessage() $e ==========");
      }
      return "";
    }
  }

  @override
  Future<bool> loadIceBreakerMessagesToCache() async {
    try {
      IceBreakerMessages? icebreakers =
          await _remoteDataSource.getIceBreakerMessages();
      _localDataSource.cacheIceBreakersAndGet(icebreakers!);
      icebreakersCacheMessages.clear();
      icebreakersCacheMessages.addAll(icebreakers.messages);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(
            "=============== repository getRandomIceBreakerMessage() $e ==========");
      }
      return false;
    }
  }

  @override
  Future<bool> loadLikedUsersToCache() async {
    try {
      ServiceResult result = await _remoteDataSource.getUsersILike();
      if (result.data is List) {
        List<LikedUser> users = result.data as List<LikedUser>;
        for (LikedUser user in users) {
          await _localDataSource.cacheLikedUser(user.likedUserId);
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
  Future<ServiceResult> sendDailyFeedback(
      String userId, String feedback, int rating) async {
    return await _remoteDataSource.sendDailyFeedback(
        DailyUserFeedbackEntity(feedback, rating, DateTime.now(), userId));
  }

  @override
  Stream<List<OperationRealTimeResult>> listenToMatches() {
    return _remoteDataSource.listenToMatches();
  }

  @override
  Future<IceBreakerMessages?> getCachedIceBreakers() async {
    return await _localDataSource.getIceBreakerMessages();
  }
}

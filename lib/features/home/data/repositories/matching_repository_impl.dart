import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/dating_profile/domain/repository/dating_profile_repo.dart';
import 'package:redting/features/home/data/data_sources/local/local_matching_data_source.dart';
import 'package:redting/features/home/data/data_sources/remote/remote_matching_data_source.dart';
import 'package:redting/features/home/data/entity/like_notification_entity.dart';
import 'package:redting/features/home/domain/models/ice_breaker_msg.dart';
import 'package:redting/features/home/domain/models/like_notification.dart';
import 'package:redting/features/home/domain/repositories/matching_repository.dart';
import 'package:redting/features/home/domain/repositories/matching_user_profile_wrapper.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/repositories/ProfileRepository.dart';
import 'package:redting/res/strings.dart';

class MatchingRepositoryImpl implements MatchingRepository {
  final ProfileRepository _profileRepository;
  final DatingProfileRepo _datingProfileRepo;
  final LocalMatchingDataSource _localDataSource;
  final RemoteMatchingDataSource _remoteDataSource;
  final List<String> icebreakersCacheMessages = [];
  MatchingRepositoryImpl(this._profileRepository, this._datingProfileRepo,
      this._localDataSource, this._remoteDataSource);

  @override
  Future<OperationResult> getDatingProfiles(
      MatchingUserProfileWrapper thisUserProfiles) async {
    return _remoteDataSource.getDatingProfiles(
        thisUserProfiles.userProfile, thisUserProfiles.datingProfile);
  }

  @override
  Future<OperationResult> getMatchingUserProfileWrapper() async {
    UserProfile? userProfile = await _profileRepository.getCachedUserProfile();
    DatingProfile? datingProfile =
        await _datingProfileRepo.getCachedDatingProfile();
    try {
      return OperationResult(
          data: MatchingUserProfileWrapper(userProfile!, datingProfile!));
    } catch (e) {
      if (kDebugMode) {
        print(
            "=============== repo getMatchingUserProfileWrapper $e $userProfile $datingProfile ==========");
      }
      return OperationResult(
          errorOccurred: true, errorMessage: loadingAuthUserErr);
    }
  }

  @override
  Future<OperationResult> likeUser(
      MatchingUserProfileWrapper thisUserProfiles, String userId) async {
    try {
      String userId = thisUserProfiles.userProfile.userId;
      String iceBreaker = await _getRandomIceBreakerMessage();
      LikeNotification notification = LikeNotificationEntity(
          likedByUserId: userId,
          likedOn: DateTime.now(),
          likedUserId: userId,
          iceBreaker: iceBreaker.isNotEmpty ? iceBreaker : defaultIceBreaker);
      OperationResult result = await _remoteDataSource.likeUser(notification);
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
            _localDataSource.getIceBreakerMessages();
        if (icebreakers != null) {
          icebreakersCacheMessages.addAll(icebreakers.messages);
        }
      }
      final random = Random();
      String iceBreaker = icebreakersCacheMessages.isNotEmpty
          ? icebreakersCacheMessages[
              random.nextInt(icebreakersCacheMessages.length)]
          : '';
      return iceBreaker;
    } catch (e) {
      if (kDebugMode) {
        print(
            "=============== repo getRandomIceBreakerMessage() $e ==========");
      }
      return "";
    }
  }

  @override
  Future loadIceBreakerMessages() async {
    try {
      IceBreakerMessages? icebreakers =
          await _remoteDataSource.getIceBreakerMessages();
      if (icebreakers != null) {
        _localDataSource.cacheIceBreakersAndGet(icebreakers);
        icebreakersCacheMessages.clear();
        icebreakersCacheMessages.addAll(icebreakers.messages);
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            "=============== repo getRandomIceBreakerMessage() $e ==========");
      }
    }
  }
}

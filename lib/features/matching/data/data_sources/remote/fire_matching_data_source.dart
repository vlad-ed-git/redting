import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:redting/core/utils/consts.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/data/data_sources/remote/fire_dating_profile.dart';
import 'package:redting/features/dating_profile/data/entities/dating_profile_entity.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/matching/data/data_sources/remote/remote_matching_data_source.dart';
import 'package:redting/features/matching/data/entities/ice_breaker_messages_entity.dart';
import 'package:redting/features/matching/data/entities/matching_profiles_entity.dart';
import 'package:redting/features/matching/domain/models/daily_user_feedback.dart';
import 'package:redting/features/matching/domain/models/ice_breaker_msg.dart';
import 'package:redting/features/matching/domain/models/like_notification.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';
import 'package:redting/features/matching/domain/utils/matching_user_profile_wrapper.dart';
import 'package:redting/features/profile/data/data_sources/remote/fire_profile.dart';
import 'package:redting/features/profile/data/entities/user_profile_entity.dart';
import 'package:redting/features/profile/data/utils/enum_mappers.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/res/strings.dart';

const String iceBreakersCollection = "ice_breakers";
const String iceBreakersDoc = "ice_breakers_doc";
const String likedUsersCollection = "liked_users";
const String usersILikeCollection = "users_i_like";
const String matchesCollection = "matches";
const String dailyUserFeedbackCollection = "daily_user_feedback";

class FireMatchingDataSource implements RemoteMatchingDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  DocumentSnapshot<Object?>? _startUserProfileMatchAfterDoc;
  DocumentSnapshot<Object?>? _startMatchesAfterDoc;

  @override
  Future<IceBreakerMessages?> getIceBreakerMessages() async {
    try {
      var doc = await _fireStore
          .collection(iceBreakersCollection)
          .doc(iceBreakersDoc)
          .get();
      IceBreakerMessages? icyBreakers;
      if (doc.data() != null) {
        icyBreakers = IceBreakerMessagesEntity.fromJson(doc.data()!);
      }
      return icyBreakers;
    } catch (e) {
      if (kDebugMode) {
        print("=============== getIceBreakerMessages() exc $e ==========");
      }
      return null;
    }
  }

  /// like user
  //TODO  if true, then this is an instant match
  Future<bool?> _isAMatch(MatchingProfiles matchingProfiles) async {
    try {
      var doc = await _fireStore
          .collection(matchesCollection)
          .doc(matchingProfiles.userAUserBIdsConcatNSorted)
          .get();
      return doc.exists;
    } catch (e) {
      if (kDebugMode) {
        print("=============== isAMatch() exc $e ==========");
      }
      return null;
    }
  }

  Future<bool> _updateToMatchProfiles(MatchingProfiles matchingProfiles) async {
    try {
      await _fireStore
          .collection(matchesCollection)
          .doc(matchingProfiles.userAUserBIdsConcatNSorted)
          .update({
        MatchingProfilesEntity.haveMatchedFieldName: true,
        MatchingProfilesEntity.likersFieldName:
            FieldValue.arrayUnion(matchingProfiles.likers),
        MatchingProfilesEntity.membersFieldName: FieldValue.arrayUnion(
            matchingProfiles
                .getMembers()
                .map((e) => e.toJson())
                .toList(growable: false))
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("=============== updateToMatchProfiles exc $e ==========");
      }
      return false;
    }
  }

  Future<bool> _addToMatchProfiles(MatchingProfiles matchingProfiles) async {
    try {
      await _fireStore
          .collection(matchesCollection)
          .doc(matchingProfiles.userAUserBIdsConcatNSorted)
          .set(matchingProfiles.toJson());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("=============== addToMatchProfiles exc $e ==========");
      }
      return false;
    }
  }

  @override
  Future<OperationResult> likeUser(LikeNotification likeNotification,
      MatchingProfiles matchingProfiles) async {
    try {
      await _fireStore
          .collection(likedUsersCollection)
          .doc(_auth.currentUser!.uid)
          .collection(usersILikeCollection)
          .doc(likeNotification.likedUserId)
          .set(likeNotification.toJson(), SetOptions(merge: true));

      bool? isAMatch = await _isAMatch(matchingProfiles);
      bool errorOccurred = isAMatch == null;
      if (isAMatch == true) {
        bool updated = await _updateToMatchProfiles(matchingProfiles);
        errorOccurred = !updated;
      }

      if (isAMatch == false) {
        bool added = await _addToMatchProfiles(matchingProfiles);
        errorOccurred = !added;
      }

      return OperationResult(errorOccurred: errorOccurred);
    } catch (e) {
      if (kDebugMode) {
        print("=============== likeUser() exc $e ==========");
      }
      return OperationResult(
          errorOccurred: true, errorMessage: likingUserFailed);
    }
  }

  /// GETTING PROFILES
  Query<Map<String, dynamic>> _getQueryForFirstUserProfileMatchesBatch(
    int lessThanAge,
    int moreThanAge,
    UserGender? myGenderPreference,
  ) {
    if (myGenderPreference != null) {
      return _fireStore
          .collection(userProfileCollection)
          .where(UserProfileEntity.ageFieldName, isLessThan: lessThanAge)
          .where(UserProfileEntity.ageFieldName, isGreaterThan: moreThanAge)
          .where(UserProfileEntity.genderFieldName,
              isEqualTo: userGenderToStringVal[myGenderPreference])
          .where(UserProfileEntity.isBannedFieldName, isEqualTo: false)
          .orderBy(UserProfileEntity.ageFieldName, descending: true)
          .limit(queryPageResultsSize);
    } else {
      return _fireStore
          .collection(userProfileCollection)
          .where(UserProfileEntity.ageFieldName, isLessThan: lessThanAge)
          .where(UserProfileEntity.ageFieldName, isGreaterThan: moreThanAge)
          .where(UserProfileEntity.isBannedFieldName, isEqualTo: false)
          .orderBy(UserProfileEntity.ageFieldName, descending: true)
          .limit(queryPageResultsSize);
    }
  }

  Query<Map<String, dynamic>> _getQueryForNextUserProfileMatchesBatch(
      int lessThanAge,
      int moreThanAge,
      UserGender? myGenderPreference,
      DocumentSnapshot<Object?> startUserProfileMatchAfterDoc) {
    if (myGenderPreference != null) {
      return _fireStore
          .collection(userProfileCollection)
          .where(UserProfileEntity.ageFieldName, isLessThan: lessThanAge)
          .where(UserProfileEntity.ageFieldName, isGreaterThan: moreThanAge)
          .where(UserProfileEntity.genderFieldName,
              isEqualTo: userGenderToStringVal[myGenderPreference])
          .where(UserProfileEntity.isBannedFieldName, isEqualTo: false)
          .orderBy(UserProfileEntity.ageFieldName, descending: true)
          .startAfterDocument(startUserProfileMatchAfterDoc)
          .limit(queryPageResultsSize);
    } else {
      return _fireStore
          .collection(userProfileCollection)
          .where(UserProfileEntity.ageFieldName, isLessThan: lessThanAge)
          .where(UserProfileEntity.ageFieldName, isGreaterThan: moreThanAge)
          .where(UserProfileEntity.isBannedFieldName, isEqualTo: false)
          .orderBy(UserProfileEntity.ageFieldName, descending: true)
          .startAfterDocument(startUserProfileMatchAfterDoc)
          .limit(queryPageResultsSize);
    }
  }

  DatingProfile? _checkIfMatchingPref(DatingProfile matchingDatingProfile,
      UserProfile thisUsersProfile, DatingProfile thisUsersDatingProfile) {
    ///filter by age

    if (matchingDatingProfile.minAgePreference <= thisUsersProfile.age &&
        matchingDatingProfile.maxAgePreference >= thisUsersProfile.age) {
      ///filter by gender preference
      UserGender? otherUserGenderPref =
          matchingDatingProfile.getGenderPreferences();
      UserGender? thisUsersGender = thisUsersProfile.getGender();
      if (otherUserGenderPref == null ||
          otherUserGenderPref == thisUsersGender) {
        //if both parties do not care about orientation
        bool filterByThisUsersOrientation =
            thisUsersDatingProfile.onlyShowMeOthersOfSameOrientation;
        bool otherUserCaresAboutOrientation =
            matchingDatingProfile.onlyShowMeOthersOfSameOrientation;
        if (!filterByThisUsersOrientation && !otherUserCaresAboutOrientation) {
          return matchingDatingProfile;
        }

        ///filter by orientation
        var thisUsersSexOrientation =
            thisUsersDatingProfile.getUserSexualOrientation().toSet();
        var otherUsersSexOrientation =
            matchingDatingProfile.getUserSexualOrientation().toSet();
        var intersection =
            thisUsersSexOrientation.intersection(otherUsersSexOrientation);
        if (intersection.isNotEmpty) {
          return matchingDatingProfile;
        }
        return null;
      }
      return null;
    }
    return null;
  }

  @override
  Future<List<MatchingUserProfileWrapper>?> getDatingProfiles(
      UserProfile thisUsersProfile,
      DatingProfile thisUsersDatingProfile) async {
    try {
      UserGender? myGenderPreference =
          thisUsersDatingProfile.getGenderPreferences();
      int lessThanAge = thisUsersDatingProfile.maxAgePreference + 1;
      int moreThanAge = thisUsersDatingProfile.minAgePreference - 1;
      Query<Map<String, dynamic>> query;
      if (_startUserProfileMatchAfterDoc != null) {
        //get the next batch
        query = _getQueryForNextUserProfileMatchesBatch(lessThanAge,
            moreThanAge, myGenderPreference, _startUserProfileMatchAfterDoc!);
      } else {
        //get the next batch
        query = _getQueryForFirstUserProfileMatchesBatch(
            lessThanAge, moreThanAge, myGenderPreference);
      }

      QuerySnapshot<Map<String, dynamic>> matchingUserProfiles =
          await query.get();

      //track the last one
      if (matchingUserProfiles.docs.isNotEmpty) {
        _startUserProfileMatchAfterDoc = matchingUserProfiles.docs.last;
      }

      /// fetch and filter out dating profiles
      List<MatchingUserProfileWrapper> matchingDatingProfilesList = [];
      for (var snapshot in matchingUserProfiles.docs) {
        try {
          UserProfile matchingUserProfile =
              UserProfileEntity.fromJson(snapshot.data());

          if (matchingUserProfile.userId == thisUsersProfile.userId) {
            continue; //skip this user if matched with self
          }

          DocumentSnapshot<Map<String, dynamic>> foundDatingProfile =
              await _fireStore
                  .collection(datingProfilesCollection)
                  .doc(matchingUserProfile.userId)
                  .get();
          if (foundDatingProfile.data() != null) {
            DatingProfile matchingDatingProfile =
                DatingProfileEntity.fromJson(foundDatingProfile.data()!);
            DatingProfile? foundMatch = _checkIfMatchingPref(
                matchingDatingProfile,
                thisUsersProfile,
                thisUsersDatingProfile);
            if (foundMatch != null) {
              matchingDatingProfilesList.add(MatchingUserProfileWrapper(
                  matchingUserProfile, matchingDatingProfile));
            }
          }
        } catch (_) {
          continue;
        }
      }
      return matchingDatingProfilesList;
    } catch (e) {
      if (kDebugMode) {
        print("================= getDatingProfiles $e =============== ");
      }
      return null;
    }
  }

  /// user feedback
  @override
  Future<OperationResult> sendDailyFeedback(
      DailyUserFeedback dailyUserFeedback) async {
    try {
      await _fireStore
          .collection(dailyUserFeedbackCollection)
          .doc()
          .set(dailyUserFeedback.toJson());
      return OperationResult();
    } catch (e) {
      if (kDebugMode) {
        print("================= sendDailyFeedback $e =============== ");
      }
      return OperationResult(errorOccurred: true);
    }
  }

  /// listen to matches
  @override
  Stream<List<OperationRealTimeResult>> listenToMatches(
      {bool loadMore = false}) {
    if (_auth.currentUser == null) return const Stream.empty();

    try {
      Query<Map<String, dynamic>> query;

      /// paginate
      if (_startMatchesAfterDoc != null && loadMore) {
        query = _fireStore
            .collection(matchesCollection)
            .where(MatchingProfilesEntity.likersFieldName,
                arrayContainsAny: [_auth.currentUser!.uid])
            .where(MatchingProfilesEntity.haveMatchedFieldName, isEqualTo: true)
            .startAfterDocument(_startMatchesAfterDoc!)
            .orderBy(MatchingProfilesEntity.orderByFieldName, descending: true)
            .limit(queryPageResultsSize);
      } else {
        query = _fireStore
            .collection(matchesCollection)
            .where(MatchingProfilesEntity.likersFieldName,
                arrayContainsAny: [_auth.currentUser!.uid])
            .where(MatchingProfilesEntity.haveMatchedFieldName, isEqualTo: true)
            .orderBy(MatchingProfilesEntity.orderByFieldName, descending: true)
            .limit(queryPageResultsSize);
      }

      //get stream
      return query.snapshots().map((event) {
        List<OperationRealTimeResult> results = [];
        for (var change in event.docChanges) {
          OperationRealTimeResult result;
          switch (change.type) {
            case DocumentChangeType.added:
              //cache the last added for pagination
              _startMatchesAfterDoc = change.doc;
              result = OperationRealTimeResult(
                data: MatchingProfilesEntity.fromJson(change.doc.data()!),
                realTimeEventType: RealTimeEventType.added,
              );
              break;
            case DocumentChangeType.modified:
              result = OperationRealTimeResult(
                data: MatchingProfilesEntity.fromJson(change.doc.data()!),
                realTimeEventType: RealTimeEventType.modified,
              );
              break;
            case DocumentChangeType.removed:
              //reset pagination cache
              if (_startMatchesAfterDoc == change.doc) {
                _startMatchesAfterDoc = null;
              }

              result = OperationRealTimeResult(
                data: MatchingProfilesEntity.fromJson(change.doc.data()!),
                realTimeEventType: RealTimeEventType.deleted,
              );
              break;
          }
          results.add(result);
        }
        return results;
      });
    } catch (e) {
      if (kDebugMode) {
        print("===============  listenToMatches exc $e ==========");
      }
      return Stream.error(e);
    }
  }
}

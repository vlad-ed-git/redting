import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:redting/core/utils/consts.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/data/data_sources/remote/remote_matching_data_source.dart';
import 'package:redting/features/matching/data/entities/ice_breaker_messages_entity.dart';
import 'package:redting/features/matching/data/entities/liked_user_entity.dart';
import 'package:redting/features/matching/data/entities/matching_profiles_entity.dart';
import 'package:redting/features/matching/domain/models/daily_user_feedback.dart';
import 'package:redting/features/matching/domain/models/ice_breaker_msg.dart';
import 'package:redting/features/matching/domain/models/liked_user.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';
import 'package:redting/features/profile/data/data_sources/remote/fire_profile.dart';
import 'package:redting/features/profile/data/entities/user_profile_entity.dart';
import 'package:redting/features/profile/data/utils/enum_mappers.dart';
import 'package:redting/features/profile/domain/models/sexual_orientation.dart';
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
  DocumentSnapshot<Object?>? _lastDocInFetchedProfilesToMatchWith;
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
  Future<OperationResult> getUsersILike() async {
    try {
      var doc = await _fireStore
          .collection(likedUsersCollection)
          .doc(_auth.currentUser!.uid)
          .collection(usersILikeCollection)
          .get();
      List<LikedUser> found = doc.docs
          .map((e) => LikedUserEntity.fromJson(e.data()))
          .toList(growable: false);
      return OperationResult(data: found);
    } catch (e) {
      if (kDebugMode) {
        print("=============== getUsersILike exc $e ==========");
      }
      return OperationResult(errorOccurred: true);
    }
  }

  @override
  Future<OperationResult> likeUser(
      LikedUser likedUser, MatchingProfiles matchingProfiles) async {
    try {
      await _fireStore
          .collection(likedUsersCollection)
          .doc(_auth.currentUser!.uid)
          .collection(usersILikeCollection)
          .doc(likedUser.likedUserId)
          .set(
            likedUser.toJson(),
          );

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

  /// GETTING PROFILES TO SWIPE
  @override
  Future<List<UserProfile>?> getProfilesToMatchWith(
    UserProfile userProfile,
  ) async {
    try {
      UserGender? usersGenderPreference = userProfile.getGenderPreferences();
      int lessThanAge = userProfile.maxAgePreference + 1;
      int moreThanAge = userProfile.minAgePreference - 1;

      Query<Map<String, dynamic>> query;
      if (_lastDocInFetchedProfilesToMatchWith != null) {
        //get the next batch
        query = _getQueryForProfilesToMatchAfterWithBatch(
            lessThanAge: lessThanAge,
            moreThanAge: moreThanAge,
            usersGenderPreference: usersGenderPreference,
            startAfterDoc: _lastDocInFetchedProfilesToMatchWith!);
      } else {
        //get the next batch
        query = _getQueryForFirstBatchProfilesToMatchWith(
            lessThanAge: lessThanAge,
            moreThanAge: moreThanAge,
            usersGenderPreference: usersGenderPreference);
      }

      QuerySnapshot<Map<String, dynamic>> fittingProfiles = await query.get();

      //track the last one
      if (fittingProfiles.docs.isNotEmpty) {
        _lastDocInFetchedProfilesToMatchWith = fittingProfiles.docs.last;
      }

      return _filterProfilesToMatchWithByGenderAndSexPreferences(
        fittingProfiles,
        userProfile,
      );
    } catch (e) {
      if (kDebugMode) {
        print("================= getDatingProfiles $e =============== ");
      }
      return null;
    }
  }

  List<UserProfile> _filterProfilesToMatchWithByGenderAndSexPreferences(
    QuerySnapshot<Map<String, dynamic>> fittingProfiles,
    UserProfile userProfile,
  ) {
    int usersAge = userProfile.age;
    UserGender? usersGender = userProfile.getGender();
    bool restrictSexualOrientation =
        userProfile.onlyShowMeOthersOfSameOrientation;
    List<SexualOrientation> usersSexOrientation =
        userProfile.getUserSexualOrientation();

    List<UserProfile> fittingProfilesList = [];
    for (var snapshot in fittingProfiles.docs) {
      UserProfile canMatchWith = UserProfileEntity.fromJson(snapshot.data());

      if (kDebugMode) {
        print(
            "==== comparing user ${userProfile.toJson()} with ${canMatchWith.toJson()} ==");
      }

      if (canMatchWith.isSameAs(userProfile)) {
        if (kDebugMode) {
          print("==== has matched with self ==");
        }
        continue; //skip the rest - user is self
      }

      /// match age
      if (canMatchWith.minAgePreference > usersAge ||
          canMatchWith.maxAgePreference < usersAge) {
        if (kDebugMode) {
          print("==== does not meet other users age criteria ==");
        }
        continue;
      }

      /// match gender?
      UserGender? otherUserGenderPref = canMatchWith.getGenderPreferences();
      bool isSuitableGender =
          otherUserGenderPref == null || otherUserGenderPref == usersGender;
      bool bothDoNotCareAboutSexualOrientation =
          canMatchWith.onlyShowMeOthersOfSameOrientation &&
              restrictSexualOrientation;
      if (isSuitableGender && bothDoNotCareAboutSexualOrientation) {
        fittingProfilesList.add(canMatchWith);
        if (kDebugMode) {
          print("==== suitable gender & do not care about sex ==");
        }
        continue; //skip the rest
      }

      ///filter by orientation
      final thisUsersSexOrientationSet = usersSexOrientation.toSet();
      final otherUsersSexOrientationSet =
          canMatchWith.getUserSexualOrientation().toSet();
      final intersectionOfSexOrientationPreferences =
          thisUsersSexOrientationSet.intersection(otherUsersSexOrientationSet);
      bool matchingSexOrientation =
          intersectionOfSexOrientationPreferences.isNotEmpty;
      if (isSuitableGender && matchingSexOrientation) {
        if (kDebugMode) {
          print("==== suitable gender & sex orientation matches ==");
        }
        fittingProfilesList.add(canMatchWith);
      }
    }
    return fittingProfilesList;
  }

  Query<Map<String, dynamic>> _getQueryForProfilesToMatchAfterWithBatch(
      {required int lessThanAge,
      required int moreThanAge,
      UserGender? usersGenderPreference,
      required DocumentSnapshot<Object?> startAfterDoc}) {
    if (usersGenderPreference != null) {
      return _fireStore
          .collection(userProfileCollection)
          .where(UserProfileEntity.ageFieldName, isLessThan: lessThanAge)
          .where(UserProfileEntity.ageFieldName, isGreaterThan: moreThanAge)
          .where(UserProfileEntity.genderFieldName,
              isEqualTo: userGenderToStringVal[usersGenderPreference])
          .where(UserProfileEntity.isBannedFieldName, isEqualTo: false)
          .orderBy(UserProfileEntity.ageFieldName, descending: true)
          .startAfterDocument(startAfterDoc)
          .limit(queryPageResultsSize);
    } else {
      return _fireStore
          .collection(userProfileCollection)
          .where(UserProfileEntity.ageFieldName, isLessThan: lessThanAge)
          .where(UserProfileEntity.ageFieldName, isGreaterThan: moreThanAge)
          .where(UserProfileEntity.isBannedFieldName, isEqualTo: false)
          .orderBy(UserProfileEntity.ageFieldName, descending: true)
          .startAfterDocument(startAfterDoc)
          .limit(queryPageResultsSize);
    }
  }

  Query<Map<String, dynamic>> _getQueryForFirstBatchProfilesToMatchWith(
      {required int lessThanAge,
      required int moreThanAge,
      UserGender? usersGenderPreference}) {
    if (usersGenderPreference != null) {
      return _fireStore
          .collection(userProfileCollection)
          .where(UserProfileEntity.ageFieldName, isLessThan: lessThanAge)
          .where(UserProfileEntity.ageFieldName, isGreaterThan: moreThanAge)
          .where(UserProfileEntity.genderFieldName,
              isEqualTo: userGenderToStringVal[usersGenderPreference])
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

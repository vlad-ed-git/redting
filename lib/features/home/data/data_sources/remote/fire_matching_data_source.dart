import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:redting/core/utils/consts.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/data/data_sources/remote/fire_dating_profile.dart';
import 'package:redting/features/dating_profile/data/entities/dating_profile_entity.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/home/data/data_sources/remote/remote_matching_data_source.dart';
import 'package:redting/features/home/data/entity/ice_breaker_messages_entity.dart';
import 'package:redting/features/home/domain/models/ice_breaker_msg.dart';
import 'package:redting/features/home/domain/models/like_notification.dart';
import 'package:redting/features/home/domain/repositories/matching_user_profile_wrapper.dart';
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

class FireMatchingDataSource implements RemoteMatchingDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  DocumentSnapshot<Object?>? _startUserProfileMatchAfterDoc;

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

  @override
  Future<OperationResult> likeUser(LikeNotification likeNotification) async {
    try {
      await _fireStore
          .collection(likedUsersCollection)
          .doc(_auth.currentUser!.uid)
          .collection(usersILikeCollection)
          .doc()
          .set(likeNotification.toJson());
      return OperationResult();
    } catch (e) {
      if (kDebugMode) {
        print("=============== likeUser() exc $e ==========");
      }
      return OperationResult(
          errorOccurred: true, errorMessage: likingUserFailed);
    }
  }

  /// GETTING PROFILES
  /// TODO REMOVE MYSELF AS A MATCH
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

  /// TODO CHECK IF THE USERS ARE NOT ALREADY IN MY LIKE LIST
  @override
  Future<OperationResult> getDatingProfiles(UserProfile thisUsersProfile,
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
      return OperationResult(data: matchingDatingProfilesList);
    } catch (e) {
      if (kDebugMode) {
        print("================= getDatingProfiles $e =============== ");
      }
      return OperationResult(errorOccurred: true);
    }
  }
}

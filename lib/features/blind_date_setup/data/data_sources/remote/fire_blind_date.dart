import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:redting/core/utils/consts.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/blind_date_setup/data/data_sources/remote/remote_source.dart';
import 'package:redting/features/blind_date_setup/data/entities/blind_date_entity.dart';
import 'package:redting/features/blind_date_setup/domain/model/blind_date.dart';
import 'package:redting/features/profile/data/data_sources/remote/fire_profile.dart';
import 'package:redting/features/profile/data/entities/user_phones_entity.dart';

const blindDatesCollection = "blind_dates";

class FireBlindDate implements RemoteBlindDateSetupSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DocumentSnapshot<Object?>? _lastFetchedBlindDate;

  @override
  Future<ServiceResult> getBlindSetupsDoneByUser(AuthUser user) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection(blindDatesCollection)
          .where(BlindDateEntity.setupByUserIdFieldName, isEqualTo: user.userId)
          .get();
      List<BlindDate> setups = [];
      if (snapshot.docs.isNotEmpty) {
        setups = snapshot.docs
            .map((e) => BlindDateEntity.fromJson(e.data()))
            .toList(growable: false);
      }
      return ServiceResult(errorOccurred: false, data: setups);
    } catch (e) {
      if (kDebugMode) {
        print("=============== getBlindSetupsDoneByUser $e =============");
      }
      return ServiceResult(errorOccurred: true);
    }
  }

  @override
  Future<ServiceResult> setupBlindDate(BlindDate blindDate) async {
    try {
      var snapshot = await _db
          .collection(blindDatesCollection)
          .where(BlindDateEntity.idFieldName, isEqualTo: blindDate.id)
          .limit(1)
          .get();

      if (snapshot.size > 0) {
        return ServiceResult(errorOccurred: false);
      }
      await _db.collection(blindDatesCollection).doc().set(blindDate.toJson());
      return ServiceResult(errorOccurred: false);
    } catch (e) {
      if (kDebugMode) {
        print("=============== setupBlindDate $e =============");
      }
      return ServiceResult(errorOccurred: true);
    }
  }

  @override
  Future<Map<String, String?>?> getIdsOfBlindDateParties(
      String user1PhoneNumber, String user2PhoneNumber) async {
    try {
      Map<String, String?> phoneToIdsMap = {
        user1PhoneNumber: null,
        user2PhoneNumber: null
      };
      var snapshot1 = await _db
          .collection(userPhonesCollection)
          .doc(user1PhoneNumber)
          .get();

      if (snapshot1.exists && snapshot1.data() != null) {
        String uid = UserPhoneEntity.fromJson(snapshot1.data()!).userId;
        phoneToIdsMap[user1PhoneNumber] = uid;
      }

      var snapshot2 = await _db
          .collection(userPhonesCollection)
          .doc(user2PhoneNumber)
          .get();
      if (snapshot2.exists && snapshot2.data() != null) {
        String uid = UserPhoneEntity.fromJson(snapshot2.data()!).userId;
        phoneToIdsMap[user2PhoneNumber] = uid;
      }
      return phoneToIdsMap;
    } catch (e) {
      if (kDebugMode) {
        print("=============== getIdsOfBlindDateParties $e =============");
      }
      return null;
    }
  }

  @override
  Future<List<BlindDate>> loadOldBlindDates(String userId) async {
    try {
      if (_lastFetchedBlindDate == null) {
        return [];
      }

      QuerySnapshot<Map<String, dynamic>> results = await _db
          .collection(blindDatesCollection)
          .where(BlindDateEntity.membersFieldName, arrayContains: userId)
          .orderBy(BlindDateEntity.orderByFieldName, descending: true)
          .startAfterDocument(_lastFetchedBlindDate!)
          .limit(queryPageResultsSize)
          .get();

      if (results.docs.isNotEmpty) {
        _lastFetchedBlindDate = results.docs.last;
        return results.docs
            .map((e) => BlindDateEntity.fromJson(e.data()))
            .toList(growable: false);
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print("============= load older messages exc $e ========");
      }
      return [];
    }
  }

  @override
  Stream<List<OperationRealTimeResult>> listenToRecentBlindDates(
    String userId,
  ) {
    try {
      Query<Map<String, dynamic>> query = _db
          .collection(blindDatesCollection)
          .where(BlindDateEntity.membersFieldName, arrayContains: userId)
          .orderBy(BlindDateEntity.orderByFieldName, descending: true)
          .limit(queryPageResultsSize);
      return query.snapshots().map((event) {
        return _mapSnapshotsToBlindDates(event);
      });
    } catch (e) {
      if (kDebugMode) {
        print("=============== listen to messages $e =========");
      }
      return const Stream.empty();
    }
  }

  List<OperationRealTimeResult> _mapSnapshotsToBlindDates(
      QuerySnapshot<Map<String, dynamic>> event) {
    List<OperationRealTimeResult> results = [];
    for (var change in event.docChanges) {
      BlindDate blindDate = BlindDateEntity.fromJson(change.doc.data()!);
      OperationRealTimeResult result;
      switch (change.type) {
        case DocumentChangeType.added:
          //cache the last added for pagination
          _lastFetchedBlindDate = change.doc;
          result = OperationRealTimeResult(
            data: blindDate,
            realTimeEventType: RealTimeEventType.added,
          );
          break;
        case DocumentChangeType.modified:
          result = OperationRealTimeResult(
            data: blindDate,
            realTimeEventType: RealTimeEventType.modified,
          );
          break;
        case DocumentChangeType.removed:
          //reset pagination cache
          if (_lastFetchedBlindDate == change.doc) {
            _lastFetchedBlindDate = null;
          }
          result = OperationRealTimeResult(
            data: blindDate,
            realTimeEventType: RealTimeEventType.deleted,
          );
          break;
      }
      results.add(result);
    }
    return results;
  }
}

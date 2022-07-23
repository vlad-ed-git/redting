import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/dating_profile/data/data_sources/entities/dating_profile_entity.dart';
import 'package:redting/features/dating_profile/data/data_sources/remote/remote_dating_profile_source.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/profile/data/utils/compressors/image_compressor.dart';
import 'package:redting/res/strings.dart';

const String datingProfilesCollection = "datingProfiles";
const String datingProfilesPhotosBucket = "datingProfilePhotos";
const String thisUserDatingProfilePhotosBucket = "myDatingProfilePhotos";

class FireDatingProfile extends RemoteDatingProfileSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Future<DatingProfile?> createDatingProfile(DatingProfile profile) async {
    try {
      await _fireStore
          .collection(datingProfilesCollection)
          .doc(profile.userId)
          .set(profile.toJson());
      return profile;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<OperationResult> getDatingProfile(String userId) async {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid == null) {
        return OperationResult(
            errorOccurred: true, errorMessage: loadingAuthUserErr);
      }
      var doc =
          await _fireStore.collection(datingProfilesCollection).doc(uid).get();
      DatingProfile? profile;
      if (doc.data() != null) {
        profile = DatingProfileEntity.fromJson(doc.data()!);
      }
      return OperationResult(data: profile);
    } catch (e) {
      return OperationResult(
          errorOccurred: true, errorMessage: getDatingProfileErr);
    }
  }

  @override
  Future<DatingProfile?> updateDatingProfile(DatingProfile profile) async {
    try {
      await _fireStore
          .collection(datingProfilesCollection)
          .doc(profile.userId)
          .update(profile.toJson());
      return profile;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> uploadPhoto(File photo, String filename, String userId,
      ImageCompressor imageCompressor) async {
    try {
      final fileToUpload =
          await imageCompressor.compressImageAndGetCompressedOrOg(photo);
      final storageRef = _storage.ref();
      final photoRef = storageRef.child(
          "$datingProfilesPhotosBucket/$userId/$thisUserDatingProfilePhotosBucket/${DateTime.now().millisecondsSinceEpoch.toString()}_$filename");
      await photoRef.putFile(fileToUpload);
      String downloadUrl = await photoRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}

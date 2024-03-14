import 'dart:io';
import "dart:math";

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:redting/features/profile/data/data_sources/remote/remote_profile_source.dart';
import 'package:redting/features/profile/data/entities/user_phones_entity.dart';
import 'package:redting/features/profile/data/entities/user_profile_entity.dart';
import 'package:redting/features/profile/data/entities/user_verification_video_entity.dart';
import 'package:redting/features/profile/data/utils/compressors/image_compressor.dart';
import 'package:redting/features/profile/data/utils/compressors/video_compressor.dart';
import 'package:redting/features/profile/domain/models/user_phones.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';
import 'package:redting/res/string_arrays.dart';

const String userProfileCollection = "users";
const String archivedProfilesCollection = "archived_users";
const String usersProfilePhotosBucket = "profilePhotos";
const String thisUserProfilePhotosBucket = "myProfilePhotos";
const String datingProfilesPhotosBucket = "datingProfilePhotos";
const String thisUserDatingProfilePhotosBucket = "myDatingProfilePhotos";

const String verificationVideosCollection = "users_verification_videos";
const String usersVerificationVideosBucket = "verificationVideos";
const String thisUserVerificationVideosBucket = "myVerificationVideos";

const userPhonesCollection = "user_phones";
const userPhonesCollectionIdField = "userId";

class FireProfile implements RemoteProfileDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Future<UserProfile?> createUserProfile({required UserProfile profile}) async {
    try {
      await _fireStore
          .collection(userProfileCollection)
          .doc(profile.userId)
          .set(profile.toJson());
      //store phone - id map
      UserPhone userPhone = UserPhoneEntity(
          userId: profile.userId, phoneNumber: _auth.currentUser!.phoneNumber!);
      await _fireStore
          .collection(userPhonesCollection)
          .doc(userPhone.phoneNumber)
          .set(userPhone.toJson());

      return profile;
    } catch (e) {
      if (kDebugMode) {
        print("============== createUserProfile --fire store $e ============");
      }
      return null;
    }
  }

  @override
  Future<UserProfile?> getUserProfile() async {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid == null) return null;

      var doc =
          await _fireStore.collection(userProfileCollection).doc(uid).get();
      UserProfile? profile;
      if (doc.data() != null) {
        profile = UserProfileEntity.fromJson(doc.data()!);
      }
      return profile;
    } catch (e) {
      if (kDebugMode) {
        print("============== getUserProfile fire store $e ============");
      }
      return null;
    }
  }

  @override
  Future<UserProfile?> updateUserProfile({required UserProfile profile}) async {
    try {
      await _fireStore
          .collection(userProfileCollection)
          .doc(profile.userId)
          .update(profile.toJson());
      return profile;
    } catch (e) {
      if (kDebugMode) {
        print("============== updateUserProfile fire store $e ============");
      }
      return null;
    }
  }

  @override
  Future<String?> uploadProfilePhoto(
      {required File file,
      required String filename,
      required ImageCompressor imageCompressor}) async {
    try {
      final fileToUpload =
          await imageCompressor.compressImageAndGetCompressedOrOg(file);
      final storageRef = _storage.ref();
      final photoRef = storageRef.child(
          "$usersProfilePhotosBucket/${_auth.currentUser!.uid}/$thisUserProfilePhotosBucket/${DateTime.now().millisecondsSinceEpoch.toString()}_$filename");
      await photoRef.putFile(fileToUpload);
      String downloadUrl = await photoRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print("============== uploadProfilePhoto fire store $e ============");
      }
      return null;
    }
  }

  /// VERIFICATION VIDEO
  @override
  Future<String?> generateVerificationWord() async {
    try {
      final List<int> possibleWordsLengths = [6, 8, 10]; //must be evens

      final random = Random();
      final int randomLength =
          possibleWordsLengths[random.nextInt(possibleWordsLengths.length)];

      String verificationWord = "";
      while (verificationWord.length < randomLength) {
        String randomConsonant = consonants[random.nextInt(consonants.length)];
        String randomVowel = vowels[random.nextInt(vowels.length)];
        verificationWord = "$verificationWord$randomConsonant$randomVowel";
      }
      return verificationWord;
    } catch (e) {
      if (kDebugMode) {
        print(
            "============== generateVerificationWord fire store $e ============");
      }
      return null;
    }
  }

  @override
  Future<UserVerificationVideo?> compressAndUploadVerificationVideo(
      {required File file,
      required String verificationCode,
      required VideoCompressor compressor}) async {
    try {
      final fileToUpload =
          await compressor.compressVideoReturnCompressedOrOg(file);
      final storageRef = _storage.ref();
      final videoRef = storageRef.child(
          "$usersVerificationVideosBucket/${_auth.currentUser!.uid}/$thisUserVerificationVideosBucket/${DateTime.now().millisecondsSinceEpoch.toString()}_vv_${verificationCode.trim()}");
      await videoRef.putFile(fileToUpload);
      String verificationVideoUrl = await videoRef.getDownloadURL();
      UserVerificationVideoEntity usersVerificationVideo =
          UserVerificationVideoEntity(
              verificationCode: verificationCode,
              videoUrl: verificationVideoUrl);
      compressor.dispose();
      await _fireStore
          .collection(verificationVideosCollection)
          .doc(_auth.currentUser!.uid)
          .set(usersVerificationVideo.toJson());
      return usersVerificationVideo;
    } catch (e) {
      if (kDebugMode) {
        print(
            "==============  compressAndUploadVerificationVideo fire store $e ============");
      }
      compressor.dispose();
      return null;
    }
  }

  @override
  Future<bool> deleteVerificationVideo() async {
    try {
      await _fireStore
          .collection(verificationVideosCollection)
          .doc(_auth.currentUser!.uid)
          .delete();
      return true; //success
    } catch (e) {
      if (kDebugMode) {
        print(
            "============== deleteVerificationVideo fire store $e ============");
      }
      return false; // fail
    }
  }

  @override
  Future<String?> uploadDatingPhoto(File photo, String filename, String userId,
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
      if (kDebugMode) {
        print("===== uploadDatingPhoto firestore exception raised $e ====");
      }
      return null;
    }
  }
}

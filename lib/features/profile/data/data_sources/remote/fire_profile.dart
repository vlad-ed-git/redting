import 'dart:io';
import "dart:math";

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/data/data_sources/remote/remote_profile_source.dart';
import 'package:redting/features/profile/data/entities/user_profile_entity.dart';
import 'package:redting/features/profile/data/entities/user_verification_video_entity.dart';
import 'package:redting/features/profile/data/utils/compressors/image_compressor.dart';
import 'package:redting/features/profile/data/utils/compressors/video_compressor.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/res/string_arrays.dart';
import 'package:redting/res/strings.dart';

const String userProfileCollection = "users";
const String archivedProfilesCollection = "archived_users";
const String usersProfilePhotosBucket = "profilePhotos";
const String thisUserProfilePhotosBucket = "myProfilePhotos";

const String verificationVideosCollection = "users_verification_videos";
const String usersVerificationVideosBucket = "verificationVideos";
const String thisUserVerificationVideosBucket = "myVerificationVideos";

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
      return profile;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<OperationResult> getUserProfile() async {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid == null) {
        return OperationResult(
            errorMessage: loadingAuthUserErr, errorOccurred: true);
      }
      var doc =
          await _fireStore.collection(userProfileCollection).doc(uid).get();
      UserProfile? profile;
      if (doc.data() != null) {
        profile = UserProfileEntity.fromJson(doc.data()!);
      }
      return OperationResult(data: profile);
    } catch (e) {
      return OperationResult(
          errorOccurred: true, errorMessage: getProfileError);
    }
  }

  @override
  Future<OperationResult> updateUserProfile(
      {required UserProfile profile}) async {
    try {
      await _fireStore
          .collection(userProfileCollection)
          .doc(profile.userId)
          .update(profile.toJson());
      return OperationResult(data: profile);
    } catch (e) {
      return OperationResult(
          errorMessage: updateProfileError, errorOccurred: true);
    }
  }

  @override
  Future<OperationResult> uploadProfilePhoto(
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
      return OperationResult(data: downloadUrl);
    } catch (e) {
      return OperationResult(
          errorMessage: uploadingPhotoErr, errorOccurred: true);
    }
  }

  /// VERIFICATION VIDEO
  @override
  Future<OperationResult> generateVerificationWord() async {
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
      return OperationResult(data: verificationWord);
    } catch (e) {
      return OperationResult(errorOccurred: true, errorMessage: "$e");
    }
  }

  @override
  Future<OperationResult> uploadVerificationVideo(
      {required File file,
      required String verificationCode,
      required VideoCompressor compressor}) async {
    try {
      final fileToUpload =
          await compressor.compressVideoReturnCompressedOrOg(file);
      final storageRef = _storage.ref();
      final videoRef = storageRef.child(
          "$usersVerificationVideosBucket/${_auth.currentUser!.uid}/$thisUserVerificationVideosBucket/${DateTime.now().millisecondsSinceEpoch.toString()}_verification_video${verificationCode.trim()}");
      await videoRef.putFile(fileToUpload);
      String verificationVideoUrl = await videoRef.getDownloadURL();
      UserVerificationVideoEntity usersVerificationVideo =
          UserVerificationVideoEntity(
              userId: _auth.currentUser!.uid,
              verificationCode: verificationCode,
              videoUrl: verificationVideoUrl);
      compressor.dispose();
      await _fireStore
          .collection(verificationVideosCollection)
          .doc(_auth.currentUser!.uid)
          .set(usersVerificationVideo.toJson());
      return OperationResult(data: usersVerificationVideo);
    } catch (e) {
      compressor.dispose();
      return OperationResult(
          errorMessage: errorUploadingVerificationVideo, errorOccurred: true);
    }
  }

  @override
  Future<OperationResult> deleteVerificationVideo() async {
    try {
      await _fireStore
          .collection(verificationVideosCollection)
          .doc(_auth.currentUser!.uid)
          .delete();
      return OperationResult();
    } catch (e) {
      return OperationResult(
          errorOccurred: true, errorMessage: deletingVerificationVideoFailed);
    }
  }
}

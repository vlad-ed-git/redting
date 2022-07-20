import 'dart:io';
import "dart:math";

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/data/data_sources/remote/remote_profile_source.dart';
import 'package:redting/features/profile/data/entities/user_verification_video_entity.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserProfile?> createUserProfile({required UserProfile profile}) {
    // TODO: implement createUserProfile
    throw UnimplementedError();
  }

  @override
  Future<OperationResult> deleteUserProfile({required UserProfile profile}) {
    // TODO: implement deleteUserProfile
    throw UnimplementedError();
  }

  @override
  Future<UserProfile?> getUserProfile() {
    // TODO: implement getUserProfile
    throw UnimplementedError();
  }

  @override
  Future<OperationResult> updateUserProfile({required UserProfile profile}) {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }

  @override
  Future<OperationResult> uploadProfilePhoto(
      {required File file, required String filename}) async {
    try {
      final storageRef = _storage.ref();
      final photoRef = storageRef.child(
          "$usersProfilePhotosBucket/${_auth.currentUser!.uid}/$thisUserProfilePhotosBucket/${DateTime.now().millisecondsSinceEpoch.toString()}_$filename");
      await photoRef.putFile(file);
      String downloadUrl = await photoRef.getDownloadURL();
      return OperationResult(data: downloadUrl);
    } catch (e) {
      return OperationResult(
          errorMessage: uploadingPhotoErr, errorOccurred: true);
    }
  }

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
      {required File file, required String verificationCode}) async {
    try {
      final storageRef = _storage.ref();
      final videoRef = storageRef.child(
          "$usersVerificationVideosBucket/${_auth.currentUser!.uid}/$thisUserVerificationVideosBucket/${DateTime.now().millisecondsSinceEpoch.toString()}_verification_video${verificationCode.trim()}");
      await videoRef.putFile(file);
      String verificationVideoUrl = await videoRef.getDownloadURL();
      UserVerificationVideoEntity usersVerificationVideo =
          UserVerificationVideoEntity(
              userId: _auth.currentUser!.uid,
              verificationCode: verificationCode,
              videoUrl: verificationVideoUrl);
      await _firestore
          .collection(verificationVideosCollection)
          .doc(_auth.currentUser!.uid)
          .set(usersVerificationVideo.toJson());
      return OperationResult(data: usersVerificationVideo);
    } catch (e) {
      return OperationResult(
          errorMessage: errorUploadingVerificationVideo, errorOccurred: true);
    }
  }

  @override
  Future<OperationResult> deleteVerificationVideo() async {
    try {
      await _firestore
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

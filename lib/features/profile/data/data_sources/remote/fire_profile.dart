import 'dart:io';
import "dart:math";

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/profile/data/data_sources/remote/remote_profile_source.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/res/string_arrays.dart';
import 'package:redting/res/strings.dart';

const String userProfileCollection = "users";
const String archivedProfilesCollection = "archived_users";
const String usersProfilePhotosBucket = "profilePhotos";
const String userProfilePhotosBucket = "myProfilePhotos";

class FireProfile implements RemoteProfileDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
  Future<OperationResult> uploadProfilePhoto({required File file}) async {
    try {
      final storageRef = _storage.ref();
      final photoRef = storageRef.child(
          "$usersProfilePhotosBucket/${_auth.currentUser!.uid}/$userProfilePhotosBucket/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg");
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
  Future<OperationResult> uploadVerificationVideo({required File file}) {
    // TODO: implement uploadVerificationVideo
    throw UnimplementedError();
  }
}

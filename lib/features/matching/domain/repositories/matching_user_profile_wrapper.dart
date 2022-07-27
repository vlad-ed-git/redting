import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

class MatchingUserProfileWrapper {
  final UserProfile userProfile;
  final DatingProfile datingProfile;
  MatchingUserProfileWrapper(this.userProfile, this.datingProfile);
}

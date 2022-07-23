import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/dating_profile/domain/models/dating_profile.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

class CurrentUserStatus {
  UserProfile? profile;
  AuthUser? authUser;
  DatingProfile? datingProfile;
  bool errorFetchingStatus;
  CurrentUserStatus(
      {this.profile,
      this.authUser,
      this.datingProfile,
      this.errorFetchingStatus = false});
}

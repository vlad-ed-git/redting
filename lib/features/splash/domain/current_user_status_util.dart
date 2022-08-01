import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';

class CurrentUserStatus {
  UserProfile? profile;
  AuthUser? authUser;
  bool errorFetchingStatus;
  CurrentUserStatus(
      {this.profile, this.authUser, this.errorFetchingStatus = false});
}

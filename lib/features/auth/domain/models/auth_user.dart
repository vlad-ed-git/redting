class AuthUser {
  String userId;
  String phoneNumber;

  AuthUser({required this.userId, required this.phoneNumber});

  bool isSameAs(AuthUser user) {
    return user.userId == userId;
  }
}

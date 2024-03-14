abstract class UserPhone {
  String userId;
  String phoneNumber;
  UserPhone({
    required this.userId,
    required this.phoneNumber,
  });
  Map<String, dynamic> toJson();
}

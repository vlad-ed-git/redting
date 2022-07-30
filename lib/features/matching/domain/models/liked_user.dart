abstract class LikedUser {
  String likedByUserId;
  String likedUserId;
  DateTime likedOn;
  LikedUser(
    this.likedByUserId,
    this.likedUserId,
    this.likedOn,
  );

  Map<String, dynamic> toJson();
  LikedUser fromJson(Map<String, dynamic> json);
}

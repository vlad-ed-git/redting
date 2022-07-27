abstract class LikeNotification {
  String likedByUserId;
  String likedUserId;
  DateTime likedOn;
  String iceBreaker;
  LikeNotification(
      this.likedByUserId, this.likedUserId, this.likedOn, this.iceBreaker);

  Map<String, dynamic> toJson();
  LikeNotification fromJson(Map<String, dynamic> json);
}

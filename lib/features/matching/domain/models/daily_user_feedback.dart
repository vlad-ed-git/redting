abstract class DailyUserFeedback {
  String userId;
  String feedback;
  int rating;
  DateTime recordedOn;

  DailyUserFeedback(this.userId, this.feedback, this.rating, this.recordedOn);

  Map<String, dynamic> toJson();
  DailyUserFeedback fromJson(Map<String, dynamic> json);
}

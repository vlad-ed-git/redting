abstract class UserVerificationVideo {
  final String userId;
  final String videoUrl;
  final String verificationCode;
  UserVerificationVideo(
      {required this.userId,
      required this.videoUrl,
      required this.verificationCode});
  bool isSameAs(UserVerificationVideo userVerificationVideo);

  UserVerificationVideo fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}

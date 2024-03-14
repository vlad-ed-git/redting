abstract class UserVerificationVideo {
  final String videoUrl;
  final String verificationCode;
  UserVerificationVideo(
      {required this.videoUrl, required this.verificationCode});
  UserVerificationVideo fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}

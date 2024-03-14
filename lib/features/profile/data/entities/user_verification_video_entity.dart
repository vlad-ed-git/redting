import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:redting/core/data/hive_type_ids.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';

part 'user_verification_video_entity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
@HiveType(typeId: userVerificationVideoTypeId)
class UserVerificationVideoEntity implements UserVerificationVideo {
  @HiveField(0)
  @override
  String verificationCode;

  @HiveField(1)
  @override
  String videoUrl;

  UserVerificationVideoEntity(
      {required this.verificationCode, required this.videoUrl});

  factory UserVerificationVideoEntity.fromJson(Map<String, dynamic> json) =>
      _$UserVerificationVideoEntityFromJson(json);
  Map<String, dynamic> toJson() => _$UserVerificationVideoEntityToJson(this);

  @override
  UserVerificationVideo fromJson(Map<String, dynamic> json) {
    return UserVerificationVideoEntity.fromJson(json);
  }
}

UserVerificationVideoEntity mapUserVerificationVideoModelToEntity(
    UserVerificationVideo verificationVideo) {
  return UserVerificationVideoEntity(
      verificationCode: verificationVideo.verificationCode,
      videoUrl: verificationVideo.videoUrl);
}

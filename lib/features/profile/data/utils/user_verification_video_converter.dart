import 'package:json_annotation/json_annotation.dart';
import 'package:redting/features/profile/data/entities/user_profile_entity.dart';
import 'package:redting/features/profile/data/entities/user_verification_video_entity.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';

class UserVerificationVideoConverter
    implements
        JsonConverter<UserVerificationVideo, UserVerificationVideoEntity> {
  const UserVerificationVideoConverter();

  @override
  UserVerificationVideo fromJson(UserVerificationVideoEntity entityJson) {
    return entityJson;
  }

  @override
  UserVerificationVideoEntity toJson(
      UserVerificationVideo userVerificationVideo) {
    return mapToUserVerificationVideoEntity(userVerificationVideo);
  }
}

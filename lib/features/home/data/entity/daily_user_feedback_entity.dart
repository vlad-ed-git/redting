import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:redting/core/utils/flutter_fire_date_time_utils.dart';
import 'package:redting/features/home/domain/models/daily_user_feedback.dart';

part 'daily_user_feedback_entity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class DailyUserFeedbackEntity implements DailyUserFeedback {
  @override
  String feedback;

  @override
  int rating;

  @TimestampConverter()
  @override
  DateTime recordedOn;

  @override
  String userId;

  DailyUserFeedbackEntity(
      this.feedback, this.rating, this.recordedOn, this.userId);

  @override
  factory DailyUserFeedbackEntity.fromJson(Map<String, dynamic> json) =>
      _$DailyUserFeedbackEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DailyUserFeedbackEntityToJson(this);

  @override
  DailyUserFeedback fromJson(Map<String, dynamic> json) {
    return DailyUserFeedbackEntity.fromJson(json);
  }
}

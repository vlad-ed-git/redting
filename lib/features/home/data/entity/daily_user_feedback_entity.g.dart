// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_user_feedback_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyUserFeedbackEntity _$DailyUserFeedbackEntityFromJson(Map json) =>
    DailyUserFeedbackEntity(
      json['feedback'] as String,
      json['rating'] as int,
      const TimestampConverter().fromJson(json['recordedOn'] as Timestamp),
      json['userId'] as String,
    );

Map<String, dynamic> _$DailyUserFeedbackEntityToJson(
        DailyUserFeedbackEntity instance) =>
    <String, dynamic>{
      'feedback': instance.feedback,
      'rating': instance.rating,
      'recordedOn': const TimestampConverter().toJson(instance.recordedOn),
      'userId': instance.userId,
    };

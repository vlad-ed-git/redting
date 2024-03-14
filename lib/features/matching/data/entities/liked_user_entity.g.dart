// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liked_user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikedUserEntity _$LikedUserEntityFromJson(Map json) => LikedUserEntity(
      likedByUserId: json['likedByUserId'] as String,
      likedOn:
          const TimestampConverter().fromJson(json['likedOn'] as Timestamp),
      likedUserId: json['likedUserId'] as String,
    );

Map<String, dynamic> _$LikedUserEntityToJson(LikedUserEntity instance) =>
    <String, dynamic>{
      'likedByUserId': instance.likedByUserId,
      'likedOn': const TimestampConverter().toJson(instance.likedOn),
      'likedUserId': instance.likedUserId,
    };

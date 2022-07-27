// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matching_profiles_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchingProfilesEntity _$MatchingProfilesEntityFromJson(Map json) =>
    MatchingProfilesEntity(
      userAUserBIdsConcatNSorted: json['userAUserBIdsConcatNSorted'] as String,
      haveMatched: json['haveMatched'] as bool? ?? false,
      iceBreakers: (json['iceBreakers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      likers:
          (json['likers'] as List<dynamic>?)?.map((e) => e as String).toList(),
      otherUser: (json['otherUser'] as List<dynamic>?)
          ?.map((e) => MatchingMembersEntity.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
      updatedOn:
          const TimestampConverter().fromJson(json['updatedOn'] as Timestamp),
    );

Map<String, dynamic> _$MatchingProfilesEntityToJson(
        MatchingProfilesEntity instance) =>
    <String, dynamic>{
      'userAUserBIdsConcatNSorted': instance.userAUserBIdsConcatNSorted,
      'iceBreakers': instance.iceBreakers,
      'likers': instance.likers,
      'haveMatched': instance.haveMatched,
      'otherUser': instance.otherUser.map((e) => e.toJson()).toList(),
      'updatedOn': const TimestampConverter().toJson(instance.updatedOn),
    };

MatchingMembersEntity _$MatchingMembersEntityFromJson(Map json) =>
    MatchingMembersEntity(
      json['userId'] as String,
      json['userName'] as String,
      json['userProfilePhotos'] as String,
    );

Map<String, dynamic> _$MatchingMembersEntityToJson(
        MatchingMembersEntity instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'userProfilePhotos': instance.userProfilePhotos,
    };

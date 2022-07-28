import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:redting/core/utils/flutter_fire_date_time_utils.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';

part 'matching_profiles_entity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class MatchingProfilesEntity implements MatchingProfiles {
  static String likersFieldName = "likers";
  static String haveMatchedFieldName = "haveMatched";
  static String membersFieldName = "otherUser";
  static Object orderByFieldName = "updatedOn";
  static var iceBreakersFieldName = "iceBreakers";

  @override
  String userAUserBIdsConcatNSorted;

  @override
  List<String> iceBreakers;

  @override
  List<String> likers;

  @override
  bool haveMatched;

  List<MatchingMembers> otherUser;

  @TimestampConverter()
  @override
  DateTime updatedOn;

  MatchingProfilesEntity(
      {required this.userAUserBIdsConcatNSorted,
      this.haveMatched = false,
      List<String>? iceBreakers,
      List<String>? likers,
      List<MatchingMembers>? otherUser,
      required this.updatedOn})
      : iceBreakers = iceBreakers ?? [],
        likers = likers ?? [],
        otherUser = otherUser ?? [];

  @override
  factory MatchingProfilesEntity.fromJson(Map<String, dynamic> json) =>
      _$MatchingProfilesEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MatchingProfilesEntityToJson(this);

  @override
  MatchingProfiles fromJson(Map<String, dynamic> json) {
    return MatchingProfilesEntity.fromJson(json);
  }

  @override
  List<MatchingMembers> getMembers() {
    return otherUser;
  }
}

@JsonSerializable(anyMap: true, explicitToJson: true)
class MatchingMembersEntity implements MatchingMembers {
  @override
  String userId;

  @override
  String userName;

  @override
  String userProfilePhoto;

  MatchingMembersEntity(this.userId, this.userName, this.userProfilePhoto);

  @override
  factory MatchingMembersEntity.fromJson(Map<String, dynamic> json) =>
      _$MatchingMembersEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MatchingMembersEntityToJson(this);

  @override
  MatchingMembers fromJson(Map<String, dynamic> json) {
    return MatchingMembersEntity.fromJson(json);
  }
}

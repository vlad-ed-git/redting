import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:redting/core/utils/flutter_fire_date_time_utils.dart';
import 'package:redting/features/blind_date_setup/domain/model/blind_date.dart';
import 'package:redting/features/matching/data/entities/matching_profiles_entity.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';
import 'package:redting/res/strings.dart';

part 'blind_date_entity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class BlindDateEntity implements BlindDate {
  static String setupByUserIdFieldName = "setupByUserId";
  static String idFieldName = "id";
  static String membersFieldName = "members";
  static String orderByFieldName = "setupOn";

  @override
  String id;

  @override
  String iceBreaker;

  @override
  String setupByUserId;

  @override
  @TimestampConverter()
  DateTime setupOn;

  @override
  List<String> members;

  BlindDateEntity(
      {required this.id,
      required this.iceBreaker,
      required this.setupByUserId,
      required this.setupOn,
      List<String>? members})
      : members = members ?? [];

  @override
  factory BlindDateEntity.fromJson(Map<String, dynamic> json) =>
      _$BlindDateEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BlindDateEntityToJson(this);

  @override
  BlindDate fromJson(Map<String, dynamic> json) {
    return BlindDateEntity.fromJson(json);
  }

  @override
  MatchingMembers toMatchingMembersType({required String thisUserId}) {
    return MatchingMembersEntity(
        thisUserId,
        "$blindDateOtherUserName ${thisUserId[0]}${thisUserId[thisUserId.length - 1]}",
        "");
  }
}

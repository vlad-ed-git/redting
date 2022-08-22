import 'package:redting/features/matching/domain/models/matching_profiles.dart';

abstract class BlindDate {
  String id;
  String setupByUserId;
  List<String> members;
  String iceBreaker;
  DateTime setupOn;
  BlindDate(
      this.id, this.setupByUserId, this.members, this.iceBreaker, this.setupOn);

  Map<String, dynamic> toJson();
  BlindDate fromJson(Map<String, dynamic> json);
  static String concatUser1User2IdsSortAndGetAsId(List<String> members) {
    String user1 = members[0];
    String user2 = members[1];
    String concatUser1User2 = "$user1$user2";
    final concatUser1User2List = concatUser1User2.split("");
    concatUser1User2List.sort((a, b) => a.compareTo(b));
    return concatUser1User2List.join("");
  }

  MatchingMembers toMatchingMembersType({required String thisUserId});
}

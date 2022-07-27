abstract class MatchingProfiles {
  List<String> iceBreakers;
  List<String> likers;
  String userAUserBIdsConcatNSorted;
  bool haveMatched;
  DateTime updatedOn;
  MatchingProfiles(this.userAUserBIdsConcatNSorted, this.iceBreakers,
      this.likers, this.haveMatched, this.updatedOn);

  Map<String, dynamic> toJson();
  MatchingProfiles fromJson(Map<String, dynamic> json);
  static String concatUser1User2IdsSortAndSetAsId(String user1, user2) {
    String concatUser1User2 = "$user1$user2";
    final concatUser1User2List = concatUser1User2.split("");
    concatUser1User2List.sort((a, b) => a.compareTo(b));
    return concatUser1User2List.join("");
  }

  List<MatchingMembers> getMembers();
}

abstract class MatchingMembers {
  String userId;
  String userName;
  String userProfilePhotos;

  MatchingMembers(this.userId, this.userName, this.userProfilePhotos);

  Map<String, dynamic> toJson();
  MatchingMembers fromJson(Map<String, dynamic> json);
}

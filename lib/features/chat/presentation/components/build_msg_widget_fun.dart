import 'package:flutter/material.dart';
import 'package:redting/features/chat/domain/models/message.dart';
import 'package:redting/features/chat/presentation/components/received_image.dart';
import 'package:redting/features/chat/presentation/components/received_message.dart';
import 'package:redting/features/chat/presentation/components/sent_image.dart';
import 'package:redting/features/chat/presentation/components/sent_message.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';
import 'package:redting/features/profile/presentation/components/view_only/profile_photo_uneditable.dart';

Widget buildMessageWidget(
    Message msg, MatchingMembers thisUser, MatchingMembers thatUser) {
  bool isSent = msg.sentBy == thisUser.userId;
  String profilePhoto =
      isSent ? thisUser.userProfilePhoto : thatUser.userProfilePhoto;

  Widget photoWidget =
      UneditableProfilePhoto(useRadius: 12, profilePhoto: profilePhoto);

  if (msg.isTxt) {
    if (isSent) {
      return SentMessage(
          key: ValueKey(msg.uid),
          msg.message ?? '',
          profileWidget: photoWidget);
    }
    return ReceivedMessage(
        key: ValueKey(msg.uid), msg.message ?? '', profileWidget: photoWidget);
  }

  if (msg.isImage) {
    if (isSent) {
      return SentImage(
          key: ValueKey(msg.uid),
          photoUrl: msg.imageUrl ?? '',
          profileWidget: photoWidget);
    }
    return ReceivedImage(
        key: ValueKey(msg.uid),
        photoUrl: msg.imageUrl ?? '',
        profileWidget: photoWidget);
  }

  return const SizedBox.shrink(); //shouldn't get here
}

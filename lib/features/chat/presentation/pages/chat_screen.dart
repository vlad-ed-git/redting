import 'package:flutter/material.dart';
import 'package:redting/core/components/screens/screen_container.dart';
import 'package:redting/features/chat/presentation/components/chat_app_bar.dart';
import 'package:redting/features/chat/presentation/components/ice_breaker_msg.dart';
import 'package:redting/features/chat/presentation/components/received_image.dart';
import 'package:redting/features/chat/presentation/components/received_message.dart';
import 'package:redting/features/chat/presentation/components/send_message.dart';
import 'package:redting/features/chat/presentation/components/sent_image.dart';
import 'package:redting/features/chat/presentation/components/sent_message.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';
import 'package:redting/res/dimens.dart';

class ChatScreen extends StatefulWidget {
  final MatchingMembers thisUser;
  final MatchingMembers thatUser;
  final String iceBreaker;
  const ChatScreen(
      {Key? key,
      required this.thisUser,
      required this.thatUser,
      required this.iceBreaker})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;
    return ScreenContainer(
        child: Scaffold(
      appBar: chatAppBar(chattingWithUser: widget.thatUser),
      body: Container(
        color: Colors.grey.withOpacity(0.1),
        constraints:
            BoxConstraints(minHeight: screenHeight, minWidth: screenWidth),
        child: Padding(
          padding: const EdgeInsets.only(
              top: paddingMd, left: paddingStd, right: paddingStd),
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ListBody(
                  children: [
                    IceBreakerMsg(iceBreaker: widget.iceBreaker),
                    SentMessage("hurrah"),
                    ReceivedMessage("yess"),
                    SentImage(photoUrl: widget.thisUser.userProfilePhoto),
                    ReceivedImage(
                      photoUrl: widget.thatUser.userProfilePhoto,
                    ),
                    const SizedBox(
                      height: 64,
                    )
                  ],
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: SendMessage(),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

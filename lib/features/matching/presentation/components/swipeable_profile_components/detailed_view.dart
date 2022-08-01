import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/features/matching/presentation/components/swipeable_profile_components/container_card.dart';
import 'package:redting/features/profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/string_maps.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';
import 'package:video_player/video_player.dart';

class DetailedViewCard extends StatefulWidget {
  final UserVerificationVideo verificationVideo;
  final List<SexualOrientation> sexualOrientation;
  final double cardWidth, cardHeight;
  final List<String> photoUrls;
  final String bio;
  const DetailedViewCard({
    Key? key,
    required this.bio,
    required this.verificationVideo,
    required this.sexualOrientation,
    required this.cardWidth,
    required this.cardHeight,
    required this.photoUrls,
  }) : super(key: key);

  @override
  State<DetailedViewCard> createState() => _DetailedViewCardState();
}

class _DetailedViewCardState extends State<DetailedViewCard> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.network(widget.verificationVideo.videoUrl)
          ..initialize().then(videoPlayerInitCallback);
  }

  FutureOr videoPlayerInitCallback(void value) {
    if (mounted) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileContainerCard(
        cardHeight: widget.cardHeight,
        cardWidth: widget.cardWidth,
        bgGradient: LinearGradient(colors: [
          appTheme.colorScheme.primary,
          appTheme.colorScheme.primary
        ]),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMediaRow(),
              Padding(
                padding: const EdgeInsets.only(
                    left: paddingStd, right: paddingStd, top: paddingSm),
                child: RichText(
                  text: TextSpan(
                    text: "\n$verificationVideoWord",
                    style: appTextTheme.caption?.copyWith(color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' ${widget.verificationVideo.verificationCode}',
                          style: appTextTheme.headline4
                              ?.copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: paddingStd,
              ),
              Padding(
                padding: const EdgeInsets.all(paddingStd),
                child: SizedBox(
                  height: widget.cardHeight / 8,
                  child: Text(
                    widget.bio,
                    textAlign: TextAlign.justify,
                    style:
                        appTextTheme.bodyText1?.copyWith(color: Colors.white),
                  ),
                ),
              ),
              ..._getUserSexualOrientationList()
            ],
          ),
        ));
  }

  Widget _getVideoWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _videoPlayerController.value.isPlaying
              ? _videoPlayerController.pause()
              : _videoPlayerController.play();
        });
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: widget.cardWidth,
            maxHeight: widget.cardHeight / 2,
            minHeight: widget.cardHeight / 2),
        child: Center(
          child: Stack(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: widget.cardWidth,
                    maxHeight: widget.cardHeight / 2),
                child: AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                ),
              ),
              Container(
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Icon(
                    Icons.play_circle,
                    color: appTheme.colorScheme.inversePrimary,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  /// IMAGES ROW & SCROL
  List<Widget> _getProfilePhotosArr() {
    return widget.photoUrls
        .map((e) => CachedNetworkImage(
              imageUrl: e,
              width: widget.cardWidth,
              height: widget.cardHeight / 2,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) {
                return Container(
                  decoration:
                      BoxDecoration(gradient: threeColorOpaqueGradientTB),
                  child: const Center(
                    child: CircularProgress(),
                  ),
                );
              },
              progressIndicatorBuilder: (_, __, ___) {
                return Container(
                  decoration:
                      BoxDecoration(gradient: threeColorOpaqueGradientTB),
                  child: const Center(
                    child: CircularProgress(),
                  ),
                );
              },
            ))
        .toList(growable: false);
  }

  _buildMediaRow() {
    return SizedBox(
      width: widget.cardWidth,
      height: widget.cardHeight / 2,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [..._getProfilePhotosArr(), _getVideoWidget()],
        ),
      ),
    );
  }

  /// SEXUAL ORIENTATION

  List<Widget> _getUserSexualOrientationList() {
    return widget.sexualOrientation
        .map((e) => Padding(
            padding: const EdgeInsets.all(paddingStd),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.black26),
              child: Padding(
                padding: const EdgeInsets.all(paddingSm),
                child: Text(
                  sexualOrientationToStrMap[e] ?? '',
                  style: appTextTheme.button?.copyWith(color: Colors.white),
                ),
              ),
            )))
        .toList(growable: false);
  }
}

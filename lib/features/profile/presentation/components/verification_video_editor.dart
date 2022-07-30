import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redting/core/components/cards/glass_card.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';
import 'package:video_player/video_player.dart';

class VerificationVideoEditor extends StatefulWidget {
  final String? verificationCode;
  final bool loadingVerificationCode;
  final bool isProcessingVideo;
  final Function(File? createdLocalVideoFile) onChanged;
  final File? localVideoFile;
  final Function(String err) onCameraError;
  final VoidCallback discardLocalVideo;
  final bool isVerified;
  const VerificationVideoEditor({
    Key? key,
    required this.verificationCode,
    required this.loadingVerificationCode,
    required this.isProcessingVideo,
    required this.onChanged,
    required this.localVideoFile,
    required this.onCameraError,
    required this.discardLocalVideo,
    required this.isVerified,
  }) : super(key: key);

  @override
  State<VerificationVideoEditor> createState() =>
      _VerificationVideoEditorState();
}

class _VerificationVideoEditorState extends State<VerificationVideoEditor> {
  final Widget _progressIndicator = const Center(
    child: CircularProgress(),
  );

  bool _isShowingPopUp = false;
  VideoPlayerController? _videoController;
  final ImagePicker _videoPicker = ImagePicker();

  _initVideoController() {
    if (_videoController == null && widget.localVideoFile != null) {
      _videoController = VideoPlayerController.file(
        widget.localVideoFile!,
      )..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          if (mounted) {
            setState(() {});
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    _initVideoController();
    return Container(
      constraints: const BoxConstraints(maxHeight: 52, maxWidth: 52),
      child: Stack(
        children: [
          InkWell(
            onTap: _onTapVideoIcon,
            child: Container(
              margin: widget.isVerified
                  ? const EdgeInsets.only(top: 8)
                  : EdgeInsets.zero,
              child: CircleAvatar(
                backgroundColor: appTheme.colorScheme.primary,
                radius: 40,
                child: !(widget.isProcessingVideo ||
                        widget.loadingVerificationCode)
                    ? Icon(
                        Icons.video_camera_front_outlined,
                        size: 32,
                        color: appTheme.colorScheme.primaryContainer,
                      )
                    : _progressIndicator,
              ),
            ),
          ),
          _getVerifiedWidgetIfVerified()
        ],
      ),
    );
  }

  Widget _getVerifiedWidgetIfVerified() {
    if (widget.isVerified) {
      return Align(
        alignment: Alignment.topRight,
        child: Icon(
          Icons.verified_user_rounded,
          size: 24,
          color: appTheme.colorScheme.inversePrimary,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  _onTapVideoIcon() {
    if (widget.verificationCode == null ||
        widget.isProcessingVideo ||
        widget.loadingVerificationCode) {
      return;
    }
    if (widget.localVideoFile == null) {
      _showRecordingInstructions();
    } else {
      _showVideoPlayer();
    }
  }

  /// VIDEO RECORD
  _pickVideo() async {
    try {
      final XFile? video = await _videoPicker.pickVideo(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
          maxDuration: const Duration(seconds: 6));
      widget.onChanged(File(video!.path));
    } catch (_) {
      widget.onCameraError(returnedVideoWasNullErr);
    }
  }

  void _showRecordingInstructions() async {
    if (_isShowingPopUp) return;
    if (mounted) {
      setState(() {
        _isShowingPopUp = true;
      });
    }

    bool? recordVideo = await showDialog<bool?>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          final navigator = Navigator.of(context);
          return AlertDialog(
              contentPadding: EdgeInsets.zero,
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              content: Container(
                constraints: const BoxConstraints(maxHeight: 400),
                child: Center(
                  child: GlassCard(
                      margins: const EdgeInsets.symmetric(
                          vertical: paddingMd, horizontal: paddingLg),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: paddingStd, horizontal: paddingMd),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            verificationVideoTitle,
                            style: appTextTheme.headline6,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: paddingStd,
                          ),
                          Text(
                            verificationVideoInstructions,
                            style: appTextTheme.subtitle2,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: paddingStd,
                          ),
                          Text(
                            widget.verificationCode!,
                            style: appTextTheme.headline5?.copyWith(
                                color: appTheme.colorScheme.primary,
                                letterSpacing: 1),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: paddingStd,
                          ),
                          Text(
                            verificationVideoHint,
                            style: appTextTheme.caption,
                            textAlign: TextAlign.justify,
                          ),
                          Center(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          appTheme.colorScheme.inversePrimary),
                                ),
                                onPressed: () {
                                  navigator.pop(true);
                                },
                                child: Text(
                                  verificationVideoInstructionsGotIt,
                                  style: appTextTheme.button,
                                  textAlign: TextAlign.center,
                                )),
                          )
                        ],
                      )),
                ),
              ));
        });

    if (mounted) {
      setState(() {
        _isShowingPopUp = false;
      });
      if (recordVideo == true) {
        _pickVideo();
      }
    }
  }

  /// VIDEO PLAY
  void _showVideoPlayer() async {
    if (_isShowingPopUp) return;
    if (mounted) {
      setState(() {
        _isShowingPopUp = true;
      });
    }

    bool? discardVideo = await showDialog<bool?>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          final navigator = Navigator.of(context);

          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              playOrPauseVideo() {
                bool isCurrentlyPlaying = _videoController!.value.isPlaying;
                isCurrentlyPlaying
                    ? _videoController!.pause()
                    : _videoController!.play();
              }

              popWithResult({bool discardTheVideo = false}) {
                if (mounted) {
                  navigator.pop(discardTheVideo);
                }
              }

              return AlertDialog(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: paddingMd, vertical: paddingLg),
                  insetPadding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  content: Center(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: VideoPlayer(_videoController!)),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            constraints: const BoxConstraints(
                              maxHeight: 70,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => appTheme.colorScheme
                                                    .inversePrimary),
                                      ),
                                      onPressed: () {
                                        popWithResult(discardTheVideo: true);
                                      },
                                      child: Text(
                                        verificationVideoDelete,
                                        style: appTextTheme.button,
                                        textAlign: TextAlign.center,
                                      )),
                                  const SizedBox(
                                    width: paddingMd,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      playOrPauseVideo();
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: appTheme.colorScheme.primary,
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: appTheme.colorScheme.onPrimary,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: paddingMd,
                                  ),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => appTheme.colorScheme
                                                    .inversePrimary),
                                      ),
                                      onPressed: () {
                                        popWithResult();
                                      },
                                      child: Text(
                                        verificationVideoKeep,
                                        style: appTextTheme.button,
                                        textAlign: TextAlign.center,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ));
            },
          );
        });

    if (mounted) {
      setState(() {
        _isShowingPopUp = false;
      });
      if (discardVideo == true) {
        widget.discardLocalVideo();
      }
    }
  }

  /// life cycle
  @override
  void deactivate() {
    if (_videoController != null) {
      _videoController!.setVolume(0.0);
      _videoController!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _videoController = null;
    super.dispose();
  }
}

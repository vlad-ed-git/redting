import 'dart:io';

import 'package:flutter/material.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/features/profile/presentation/components/video_recorder.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class VerificationVideo extends StatefulWidget {
  final String? verificationCode;
  final bool loadingVerificationCode;
  final bool isUploadingVideo;
  final String? profileVerificationVideo;
  final Function(File? createdLocalVideoFile) onChanged;
  final File? localVideoFile;
  final Function(String err) onCameraError;
  const VerificationVideo(
      {Key? key,
      required this.verificationCode,
      required this.loadingVerificationCode,
      required this.isUploadingVideo,
      this.profileVerificationVideo,
      required this.onChanged,
      required this.localVideoFile,
      required this.onCameraError})
      : super(key: key);

  @override
  State<VerificationVideo> createState() => _VerificationVideoState();
}

class _VerificationVideoState extends State<VerificationVideo> {
  final Widget _progressIndicator = const Center(
    child: CircularProgress(),
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.verificationCode == null) {
          return;
        }
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CameraRecorder(
                onCameraError: widget.onCameraError,
                screenTitle: verificationVideoTitle,
                recordInstructions: pleaseSay,
                recordInstructionsExtra: widget.verificationCode,
              ),
            ));
      },
      child: CircleAvatar(
        backgroundColor: appTheme.colorScheme.primary,
        radius: 40,
        child: !widget.isUploadingVideo
            ? Icon(
                Icons.video_camera_front_outlined,
                size: 32,
                color: appTheme.colorScheme.primaryContainer,
              )
            : _progressIndicator,
      ),
    );
  }
}

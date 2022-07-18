import 'dart:io';

import 'package:flutter/material.dart';
import 'package:redting/res/theme.dart';

class VerificationVideo extends StatelessWidget {
  final String? verificationCode;
  final bool loadingVerificationCode;
  final bool isUploadingVideo;
  final String? profileVerificationVideo;
  final Function(File? createdLocalVideoFile) onChanged;
  final File? localVideoFile;
  const VerificationVideo(
      {Key? key,
      required this.verificationCode,
      required this.loadingVerificationCode,
      required this.isUploadingVideo,
      this.profileVerificationVideo,
      required this.onChanged,
      required this.localVideoFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(verificationCode);
      },
      child: CircleAvatar(
        backgroundColor: appTheme.colorScheme.primary,
        radius: 40,
        child: Icon(
          Icons.video_camera_front_outlined,
          size: 32,
          color: appTheme.colorScheme.primaryContainer,
        ),
      ),
    );
  }
}

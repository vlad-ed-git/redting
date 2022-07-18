import 'package:flutter/material.dart';
import 'package:redting/res/theme.dart';

class VerificationVideo extends StatelessWidget {
  const VerificationVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: appTheme.colorScheme.primary,
      radius: 40,
      child: Icon(
        Icons.video_camera_front_outlined,
        size: 32,
        color: appTheme.colorScheme.primaryContainer,
      ),
    );
  }
}

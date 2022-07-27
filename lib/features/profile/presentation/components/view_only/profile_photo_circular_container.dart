import 'package:flutter/material.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/theme.dart';

class ProfilePhotoCircularContainer extends StatelessWidget {
  final ImageProvider? imageProvider;
  final Widget? child;
  const ProfilePhotoCircularContainer(
      {Key? key, this.imageProvider, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: appTheme.colorScheme.inversePrimary,
      radius: avatarRadiusLg,
      backgroundImage: imageProvider,
      child: child,
    );
  }
}

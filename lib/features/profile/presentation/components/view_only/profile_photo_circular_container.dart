import 'package:flutter/material.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/theme.dart';

class ProfilePhotoCircularContainer extends StatelessWidget {
  final ImageProvider? imageProvider;
  final Widget? child;
  final bool isSmall, isSmallest;
  final double? useRadius;
  const ProfilePhotoCircularContainer(
      {Key? key,
      this.imageProvider,
      this.child,
      this.isSmall = false,
      this.isSmallest = false,
      this.useRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: appTheme.colorScheme.inversePrimary,
      radius: useRadius ??
          (isSmallest
              ? avatarRadiusSmallest
              : (isSmall ? avatarRadiusSmall : avatarRadiusLg)),
      backgroundImage: imageProvider,
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/core/components/screens/screen_container.dart';
import 'package:redting/features/profile/presentation/components/app_bars/build_edit_profile_appbar.dart';
import 'package:redting/res/dimens.dart';

class EditProfileContainer extends StatelessWidget {
  final VoidCallback onSaveProfile;
  final Widget child;
  const EditProfileContainer(
      {Key? key, required this.onSaveProfile, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return ScreenContainer(
        child: Scaffold(
            extendBodyBehindAppBar: false,
            appBar: buildEditProfileAppBar(onSaveProfile: onSaveProfile),
            body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                    decoration:
                        BoxDecoration(gradient: threeColorOpaqueGradientTB),
                    constraints: BoxConstraints(
                        minWidth: screenWidth, minHeight: screenHeight),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: paddingMd, horizontal: paddingStd),
                        child: child)))));
    ;
  }
}

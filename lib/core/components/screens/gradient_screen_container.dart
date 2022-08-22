import 'package:flutter/material.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/res/dimens.dart';

class GradientScreenContainer extends StatelessWidget {
  final Widget screen;
  final BoxDecoration? decor;
  const GradientScreenContainer({Key? key, required this.screen, this.decor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
        decoration:
            decor ?? BoxDecoration(gradient: threeColorOpaqueGradientTB),
        constraints: BoxConstraints(
            minWidth: screenWidth,
            minHeight: screenHeight,
            maxHeight: screenHeight,
            maxWidth: screenWidth),
        child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: paddingMd, horizontal: paddingStd),
            child: screen));
  }
}

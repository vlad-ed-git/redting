import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class StdAppName extends StatelessWidget {
  final bool large;
  final Color? firstPartTxtColor, secondPartTxtColor;
  const StdAppName(
      {Key? key,
      this.large = false,
      this.firstPartTxtColor,
      this.secondPartTxtColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle? txtTheme =
        large ? appTextTheme.headline1 : appTextTheme.headline2;
    return RichText(
        text: TextSpan(
      children: <TextSpan>[
        TextSpan(
            text: appNameFirstWord,
            style: txtTheme?.copyWith(
              color: firstPartTxtColor ??
                  appTheme.colorScheme.primary.withOpacity(0.5),
            )),
        TextSpan(
            text: appNameLastWord,
            style: txtTheme?.copyWith(
                color: secondPartTxtColor ?? appTheme.colorScheme.primary)),
      ],
    ));
  }
}

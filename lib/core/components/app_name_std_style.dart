import 'package:flutter/widgets.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class StdAppName extends StatelessWidget {
  const StdAppName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
      children: <TextSpan>[
        TextSpan(
            text: appNameFirstWord,
            style: appTextTheme.headline2?.copyWith(
              color: appTheme.colorScheme.primary.withOpacity(0.5),
            )),
        TextSpan(
            text: appNameLastWord,
            style: appTextTheme.headline2
                ?.copyWith(color: appTheme.colorScheme.primary)),
      ],
    ));
  }
}

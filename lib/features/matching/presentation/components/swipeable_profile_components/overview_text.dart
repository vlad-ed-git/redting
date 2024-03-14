import 'package:flutter/material.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/theme.dart';

class OverviewText extends StatelessWidget {
  final String name;
  final String age;
  final String title;
  final double cardWidth;
  const OverviewText(
      {Key? key,
      required this.name,
      required this.age,
      required this.title,
      required this.cardWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(paddingStd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: appTextTheme.subtitle1
                      ?.copyWith(color: appTheme.colorScheme.onPrimary),
                ),
                const SizedBox(
                  width: paddingStd,
                ),
                Expanded(
                    child: Text(age,
                        style: appTextTheme.headline6
                            ?.copyWith(color: appTheme.colorScheme.onPrimary)))
              ],
            ),
            Text(
              title.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: appTextTheme.bodyText1
                  ?.copyWith(color: appTheme.colorScheme.onPrimary),
            )
          ],
        ),
      ),
    );
  }
}

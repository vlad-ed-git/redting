import 'package:flutter/material.dart';
import 'package:redting/features/matching/presentation/components/swipeable_profile.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class CardStamp extends StatelessWidget {
  final CardSwipeType forType;

  const CardStamp({Key? key, required this.forType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String stampTxt = "";
    EdgeInsets pushByMargin = EdgeInsets.zero;
    switch (forType) {
      case CardSwipeType.like:
        stampTxt = likeStamp;
        pushByMargin = const EdgeInsets.only(right: 40);
        break;
      case CardSwipeType.pass:
        stampTxt = passStamp;
        pushByMargin = const EdgeInsets.only(left: 40);
        break;
      case CardSwipeType.superlike:
        break;
      case CardSwipeType.noAction:
        break;
    }
    return Container(
      margin: pushByMargin,
      decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: appTheme.colorScheme.inversePrimary, width: 2)),
      child: Padding(
        padding: const EdgeInsets.all(paddingStd),
        child: Text(
          stampTxt,
          style: appTextTheme.headline3
              ?.copyWith(color: appTheme.colorScheme.inversePrimary),
        ),
      ),
    );
  }
}

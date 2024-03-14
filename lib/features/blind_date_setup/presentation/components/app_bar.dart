import 'package:flutter/material.dart';
import 'package:redting/res/assets_paths.dart';
import 'package:redting/res/dimens.dart';

PreferredSizeWidget buildBlindDateScreenAppBar() {
  return AppBar(
    toolbarHeight: appBarHeight,
    title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            redLogoPath,
            height: appBarHeight - (paddingStd * 2),
            fit: BoxFit.fitHeight,
          ),
        ]),
  );
}

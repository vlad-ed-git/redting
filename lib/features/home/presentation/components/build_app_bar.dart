import 'package:flutter/material.dart';
import 'package:redting/res/assets_paths.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

PreferredSizeWidget buildAppBar(
    {required VoidCallback onSettingsClicked,
    required VoidCallback onSetupBlindDateClicked}) {
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
    actions: [
      IconButton(
          iconSize: 32,
          onPressed: onSetupBlindDateClicked,
          icon: Icon(
            Icons.group_add_outlined,
            size: 32,
            semanticLabel: blindDateSetupSemanticLbl,
            color: appTheme.colorScheme.primary,
          )),
      IconButton(
          iconSize: 32,
          onPressed: onSettingsClicked,
          icon: Icon(
            Icons.settings,
            size: 32,
            semanticLabel: editDatingPreferencesSemanticLbl,
            color: appTheme.colorScheme.primary,
          ))
    ],
  );
}

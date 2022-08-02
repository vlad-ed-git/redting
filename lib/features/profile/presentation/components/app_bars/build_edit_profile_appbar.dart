import 'package:flutter/material.dart';
import 'package:redting/res/assets_paths.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/theme.dart';

PreferredSizeWidget buildEditProfileAppBar(
    {required VoidCallback onSaveProfile}) {
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
          onPressed: onSaveProfile,
          icon: Icon(
            Icons.check_circle,
            size: 32,
            color: appTheme.colorScheme.primary,
          ))
    ],
  );
}

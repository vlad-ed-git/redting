import 'package:flutter/material.dart';
import 'package:redting/res/colors.dart';
import 'package:redting/res/fonts.dart';

var appTheme = ThemeData(
    useMaterial3: true, colorSchemeSeed: seedColor, textTheme: appTextTheme);

var darkTheme = appTheme.copyWith(brightness: Brightness.dark);

var lightTheme = appTheme.copyWith(brightness: Brightness.light);

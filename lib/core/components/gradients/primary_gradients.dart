import 'package:flutter/widgets.dart';
import 'package:redting/res/theme.dart';

var twoColorOpaquePrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      appTheme.colorScheme.primary.withOpacity(0.1),
      appTheme.colorScheme.primary.withOpacity(0.2)
    ]);

var threeColorOpaqueGradientTB = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      appTheme.colorScheme.inversePrimary.withOpacity(0.1),
      appTheme.colorScheme.inversePrimary.withOpacity(0.4),
      appTheme.colorScheme.inversePrimary.withOpacity(0.6),
    ]);

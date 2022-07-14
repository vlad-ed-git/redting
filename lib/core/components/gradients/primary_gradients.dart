import 'package:flutter/widgets.dart';
import 'package:redting/res/theme.dart';

var twoColorOpaquePrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      appTheme.colorScheme.primary.withOpacity(0.1),
      appTheme.colorScheme.primary.withOpacity(0.2)
    ]);

var fiveColorOpaqueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      appTheme.colorScheme.inversePrimary.withOpacity(0.2),
      appTheme.colorScheme.inversePrimary.withOpacity(0.4),
      appTheme.colorScheme.inversePrimary.withOpacity(0.6),
      appTheme.colorScheme.inversePrimary.withOpacity(0.8),
      appTheme.colorScheme.inversePrimary,
    ]);

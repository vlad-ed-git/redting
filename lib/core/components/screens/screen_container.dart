import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenContainer extends StatelessWidget {
  final Widget child;
  final Color? statusBarColor;
  final Brightness? iconBrightness;
  const ScreenContainer(
      {Key? key, required this.child, this.statusBarColor, this.iconBrightness})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: statusBarColor ?? Colors.transparent,
            statusBarIconBrightness: iconBrightness ?? Brightness.dark),
        child: child);
  }
}

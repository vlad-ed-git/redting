import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScaffoldWrapper extends StatelessWidget {
  final Widget child;
  final Color? statusBarColor;
  const ScaffoldWrapper({
    Key? key,
    required this.child,
    this.statusBarColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: brightness == Brightness.dark
              ? Colors.transparent
              : Colors.black26,
        ),
        child: child);
  }
}

import 'package:flutter/material.dart';
import 'package:redting/res/theme.dart';

class CircularProgress extends StatelessWidget {
  final bool makeSmaller;
  const CircularProgress({Key? key, this.makeSmaller = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: makeSmaller ? 16 : 24,
      height: makeSmaller ? 16 : 24,
      child: CircularProgressIndicator(
        strokeWidth: makeSmaller ? 3 : 4,
        backgroundColor: appTheme.colorScheme.inversePrimary,
        color: appTheme.colorScheme.primary,
      ),
    );
  }
}

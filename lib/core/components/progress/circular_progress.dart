import 'package:flutter/material.dart';
import 'package:redting/res/theme.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        backgroundColor: appTheme.colorScheme.inversePrimary,
        color: appTheme.colorScheme.primary,
      ),
    );
  }
}

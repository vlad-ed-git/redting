import 'package:flutter/material.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/theme.dart';

class Snack {
  final String content;
  final Function? action;
  final String actionLbl;
  final bool isError;

  const Snack(
      {Key? key,
      required this.content,
      this.action,
      this.actionLbl = '',
      this.isError = false});

  SnackBar create(context) {
    return SnackBar(
        elevation: 12.0,
        duration: const Duration(seconds: 5),
        content: Text(
          content,
          style: appTextTheme.bodyText2?.copyWith(
              fontWeight: FontWeight.bold,
              color: isError
                  ? appTheme.colorScheme.error
                  : appTheme.colorScheme.primary),
        ),
        action: action != null
            ? SnackBarAction(
                label: actionLbl.toUpperCase(),
                onPressed: () => action!(),
                textColor: appTheme.colorScheme.primary,
              )
            : null,
        backgroundColor: isError
            ? appTheme.colorScheme.inversePrimary.withOpacity(0.3)
            : Colors.white);
  }
}

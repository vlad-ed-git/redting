import 'package:flutter/material.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/theme.dart';

class SentMessage extends StatelessWidget {
  final String message;
  const SentMessage(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
        margin: const EdgeInsets.only(top: paddingMd),
        decoration: BoxDecoration(
            color: appTheme.colorScheme.inversePrimary,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                topRight: Radius.circular(12))),
        child: Padding(
          padding: const EdgeInsets.all(paddingStd),
          child: Text(
            message,
            style: appTextTheme.bodyText1?.copyWith(color: Colors.black),
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }
}

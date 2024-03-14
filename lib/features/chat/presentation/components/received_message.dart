import 'package:flutter/material.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/theme.dart';

class ReceivedMessage extends StatelessWidget {
  final String message;
  final Widget profileWidget;
  const ReceivedMessage(this.message, {Key? key, required this.profileWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          profileWidget,
          const SizedBox(
            width: paddingSm,
          ),
          Container(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
            margin: const EdgeInsets.only(top: paddingMd),
            decoration: BoxDecoration(
                color: appTheme.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    topLeft: Radius.circular(12))),
            child: Padding(
              padding: const EdgeInsets.all(paddingStd),
              child: Text(
                message,
                style: appTextTheme.bodyText1
                    ?.copyWith(color: appTheme.colorScheme.onPrimary),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

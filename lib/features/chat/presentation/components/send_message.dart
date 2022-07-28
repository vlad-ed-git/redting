import 'package:flutter/material.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/theme.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({Key? key}) : super(key: key);

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: paddingStd),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                child: TextField(
              maxLines: 6,
              minLines: 1,
              style: appTextTheme.bodyText1?.copyWith(color: Colors.black),
              decoration: const InputDecoration(
                  isDense: true, border: InputBorder.none),
            )),
            const SizedBox(
              width: paddingStd,
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                  size: 32,
                  color: appTheme.colorScheme.primary,
                )),
            const SizedBox(
              width: paddingSm,
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.photo_camera,
                  size: 32,
                  color: Colors.black54,
                ))
          ],
        ),
      ),
    );
  }
}

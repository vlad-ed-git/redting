import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/theme.dart';

class SendMessage extends StatelessWidget {
  final bool isSendingMessage;
  final VoidCallback onSendTxtMessage;
  final TextEditingController txtMsgController;
  final Function({required String fileName, required File imageFile})
      onSendImageMessage;
  const SendMessage(
      {Key? key,
      required this.isSendingMessage,
      required this.onSendTxtMessage,
      required this.txtMsgController,
      required this.onSendImageMessage})
      : super(key: key);

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
              controller: txtMsgController,
              maxLines: 6,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              style: appTextTheme.bodyText1?.copyWith(color: Colors.black),
              decoration: const InputDecoration(
                  isDense: true, border: InputBorder.none),
            )),
            Visibility(
                visible: !isSendingMessage,
                child: Container(
                  margin: const EdgeInsets.only(left: paddingSm),
                  child: IconButton(
                      onPressed: _sendMessage,
                      icon: Icon(
                        Icons.send,
                        size: 32,
                        color: appTheme.colorScheme.primary,
                      )),
                )),
            Visibility(
              visible: !isSendingMessage,
              child: Container(
                margin: const EdgeInsets.only(left: paddingSm),
                child: IconButton(
                    onPressed: () {
                      _sendImageMessage();
                    },
                    icon: const Icon(
                      Icons.photo_camera,
                      size: 32,
                      color: Colors.black54,
                    )),
              ),
            ),
            Visibility(
              visible: isSendingMessage,
              child: Container(
                  margin: const EdgeInsets.only(bottom: paddingSm),
                  child: const CircularProgress(
                    makeSmaller: true,
                  )),
            )
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (isSendingMessage) return;
    FocusManager.instance.primaryFocus?.unfocus();
    onSendTxtMessage();
  }

  void _sendImageMessage() async {
    if (isSendingMessage) return;
    ImagePicker _picker = ImagePicker();
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      onSendImageMessage(fileName: file.name, imageFile: File(file.path));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/theme.dart';

class OutlinedTxtField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction? txtInputAction;
  final String? prefixText, hintTxt;
  const OutlinedTxtField(
      {Key? key,
      required this.controller,
      required this.keyboardType,
      this.txtInputAction,
      this.prefixText,
      this.hintTxt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle? txtStyle = keyboardType == TextInputType.phone
        ? appTextTheme.headline6?.copyWith(letterSpacing: 2)
        : appTextTheme.bodyText1;
    return TextField(
      textInputAction: txtInputAction ?? TextInputAction.next,
      controller: controller,
      keyboardType: keyboardType,
      enabled: keyboardType != TextInputType.none,
      showCursor: keyboardType != TextInputType.none,
      style: txtStyle,
      decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          prefixStyle: txtStyle,
          prefixText: prefixText,
          hintText: hintTxt,
          hintStyle: appTextTheme.caption?.copyWith(color: Colors.black),
          focusedBorder: _getBorder(isFocused: true),
          disabledBorder: _getBorder(isDisabled: true),
          errorBorder: _getBorder(isError: true),
          border: _getBorder()),
    );
  }

  _getBorder({
    bool isFocused = false,
    bool isError = false,
    bool isDisabled = false,
  }) {
    ColorScheme colorScheme = appTheme.colorScheme;
    Color borderColor = isFocused
        ? colorScheme.inversePrimary
        : isDisabled
            ? Colors.grey
            : isError
                ? colorScheme.error
                : Colors.black45;
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            BorderSide(color: borderColor, width: isFocused ? 2.0 : 1.0));
  }
}

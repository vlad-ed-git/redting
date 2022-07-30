import 'package:flutter/material.dart';
import 'package:redting/res/fonts.dart';

class UnStyledTxtInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final BoxConstraints? constraints;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final String? label;
  final int? maxCharacters;
  final Function(String)? onTxtChanged;
  final Function()? onTap;
  final Color? txtColor;
  const UnStyledTxtInput(
      {Key? key,
      required this.controller,
      required this.hint,
      this.constraints,
      this.keyboardType,
      this.textAlign,
      this.label,
      this.maxCharacters,
      this.onTxtChanged,
      this.onTap,
      this.txtColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLongTxt = keyboardType == TextInputType.multiline;
    return GestureDetector(
      onTap: onTap,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        minLines: isLongTxt ? 3 : 1,
        maxLines: isLongTxt ? 5 : 1,
        maxLength: maxCharacters,
        showCursor: keyboardType != TextInputType.none,
        enabled: keyboardType != TextInputType.none,
        decoration: InputDecoration(
            labelStyle: appTextTheme.headline6
                ?.copyWith(color: txtColor ?? Colors.black),
            helperStyle: appTextTheme.caption
                ?.copyWith(fontSize: 12, fontWeight: FontWeight.w200),
            labelText: label,
            floatingLabelBehavior: isLongTxt
                ? FloatingLabelBehavior.always
                : FloatingLabelBehavior.auto,
            isDense: true,
            hintText: hint,
            constraints: constraints,
            hintStyle: appTextTheme.bodyText2
                ?.copyWith(color: txtColor ?? Colors.black),
            border:
                isLongTxt ? const UnderlineInputBorder() : InputBorder.none),
        textAlign: textAlign ?? TextAlign.start,
        onChanged: onTxtChanged,
        style: keyboardType == TextInputType.number
            ? appTextTheme.headline6?.copyWith(color: txtColor ?? Colors.black)
            : appTextTheme.bodyText1?.copyWith(color: txtColor ?? Colors.black),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/res/fonts.dart';

class MainElevatedBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final bool showLoading;
  final String lbl;
  final String? loadingLbl;
  const MainElevatedBtn(
      {Key? key,
      required this.onPressed,
      required this.showLoading,
      required this.lbl,
      this.loadingLbl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: showLoading,
            child: const CircularProgress(),
          ),
          Expanded(
            child: Text(
              showLoading
                  ? (loadingLbl ?? lbl.toUpperCase())
                  : lbl.toUpperCase(),
              style: appTextTheme.button?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
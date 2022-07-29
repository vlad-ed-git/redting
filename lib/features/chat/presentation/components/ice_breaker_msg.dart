import 'package:flutter/material.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/theme.dart';

class IceBreakerMsg extends StatelessWidget {
  final String iceBreaker;
  const IceBreakerMsg({Key? key, required this.iceBreaker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      margin: const EdgeInsets.symmetric(
          horizontal: paddingStd, vertical: paddingMd),
      child: Stack(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              child: Material(
                shadowColor: appTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                elevation: paddingStd,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: paddingMd, horizontal: paddingStd),
                  child: Text(
                    iceBreaker,
                    style:
                        appTextTheme.bodyText2?.copyWith(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.light_mode,
              color: appTheme.colorScheme.primary,
              size: 32,
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/res/dimens.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets margins;
  final BoxConstraints constraints;
  final EdgeInsets contentPadding;
  final double borderRadius;
  final Gradient? gradient;
  const GlassCard(
      {Key? key,
      required this.child,
      this.constraints = const BoxConstraints(
        minHeight: 300,
        maxHeight: 300,
      ),
      this.margins = const EdgeInsets.only(bottom: paddingMd),
      this.contentPadding = const EdgeInsets.all(paddingMd),
      this.borderRadius = 14.0,
      this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margins,
        alignment: Alignment.center,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(
                  constraints: constraints,
                  decoration: BoxDecoration(
                    gradient: gradient ?? twoColorOpaquePrimaryGradient,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Padding(
                    padding: contentPadding,
                    child: SingleChildScrollView(child: child),
                  )),
            )));
  }
}

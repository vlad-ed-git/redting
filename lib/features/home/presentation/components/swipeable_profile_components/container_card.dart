import 'package:flutter/material.dart';
import 'package:redting/core/components/cards/glass_card.dart';

class ProfileContainerCard extends StatelessWidget {
  final Widget child;
  final double cardWidth, cardHeight;
  final Gradient? bgGradient;
  const ProfileContainerCard(
      {Key? key,
      required this.child,
      required this.cardWidth,
      required this.cardHeight,
      this.bgGradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
        gradient: bgGradient,
        wrapInChildScrollable: false,
        constraints: BoxConstraints(
          maxWidth: cardWidth,
          minHeight: cardHeight,
          maxHeight: cardHeight,
        ),
        contentPadding: EdgeInsets.zero,
        child: child);
  }
}

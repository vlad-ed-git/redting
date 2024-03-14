import 'package:flutter/material.dart';
import 'package:redting/core/components/cards/glass_card.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class IdleMatchingCard extends StatelessWidget {
  const IdleMatchingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;
    return GlassCard(
      wrapInChildScrollable: false,
      constraints: BoxConstraints(
        maxWidth: screenWidth - 40,
        minWidth: 300,
        minHeight: screenHeight * 0.5,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.people_alt_outlined,
              color: appTheme.colorScheme.primary,
              size: 64,
            ),
            Text(
              beAuthenticAlways,
              style: appTextTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

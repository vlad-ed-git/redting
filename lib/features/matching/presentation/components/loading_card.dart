import 'package:flutter/material.dart';
import 'package:redting/core/components/cards/glass_card.dart';
import 'package:redting/core/components/progress/circular_progress.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({Key? key}) : super(key: key);

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
        minHeight: screenHeight * 0.7,
        maxHeight: screenHeight * 0.7,
      ),
      child: const Center(
        child: CircularProgress(),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TransparentLayer extends StatelessWidget {
  const TransparentLayer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
      Colors.transparent,
      Colors.black,
    ], stops: [
      0.7,
      1
    ], begin: Alignment.topCenter, end: Alignment.bottomCenter)));
  }
}

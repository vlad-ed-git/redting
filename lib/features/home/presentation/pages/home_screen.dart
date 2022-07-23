import 'package:flutter/material.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/core/components/screens/screen_container.dart';
import 'package:redting/res/dimens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return ScreenContainer(
        child: Scaffold(
            extendBodyBehindAppBar: true,
            body: Container(
                constraints: BoxConstraints(
                    minHeight: screenHeight, minWidth: screenWidth),
                decoration: BoxDecoration(gradient: fiveColorOpaqueGradient),
                child: Padding(
                  padding: const EdgeInsets.all(paddingMd),
                ))));
  }
}

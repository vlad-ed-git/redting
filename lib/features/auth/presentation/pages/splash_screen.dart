import 'package:flutter/material.dart';
import 'package:redting/core/components/app_name_std_style.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _checkingAuthState = false;

  @override
  void initState() {
    _checkingAuthState = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(paddingMd),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const StdAppName(),
            Visibility(
                visible: _checkingAuthState,
                child: Center(
                  child: CircularProgressIndicator(
                    color: appTheme.colorScheme.primary,
                    backgroundColor: appTheme.colorScheme.primaryContainer,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

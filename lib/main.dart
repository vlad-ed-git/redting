import 'package:flutter/material.dart';
import 'package:redting/main_init.dart';
import 'package:redting/res/routes.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MainAppInit.init();
  //todo - app check before release
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      darkTheme: darkTheme,
      theme: lightTheme,
      routes: appRoutes,
    );
  }
}

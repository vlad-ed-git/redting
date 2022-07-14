import 'package:flutter/material.dart';
import 'package:redting/core/data/local_storage.dart';
import 'package:redting/main_init.dart';
import 'package:redting/res/routes.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MainAppInit.initApp();
  //todo - app check before release
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    LocalStorage.dispose();
    super.dispose();
  }

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

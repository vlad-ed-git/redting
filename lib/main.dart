import 'package:flutter/material.dart';
import 'package:redting/core/data/local_storage.dart';
import 'package:redting/main_init.dart';
import 'package:redting/res/routes.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isInitProperly = await MainAppInit.initApp();
  runApp(MyApp(isInit: isInitProperly)); //todo - app check before release
}

class MyApp extends StatefulWidget {
  final bool isInit;
  const MyApp({Key? key, required this.isInit}) : super(key: key);

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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MaterialApp(
        title: appName,
        darkTheme: darkTheme,
        theme: lightTheme,
        routes: appRoutes,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/core/components/screens/screen_container.dart';
import 'package:redting/core/components/text/app_name_std_style.dart';
import 'package:redting/features/matching/presentation/pages/matched_screen.dart';
import 'package:redting/features/matching/presentation/pages/matching_screen.dart';
import 'package:redting/features/profile/presentation/pages/view_profile_destination.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //destinations
  HomeDestinations _homeDestinations = HomeDestinations.matching;
  late List<Widget> _destinationScreens;
  late PageController _destinationPagesController;

  @override
  void initState() {
    _destinationScreens = [
      const MatchingScreen(),
      const MatchedScreen(),
      const ViewProfileScreen(),
    ];

    _destinationPagesController =
        PageController(initialPage: _getSelectedIndex());
    super.initState();
  }

  @override
  void dispose() {
    _destinationPagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
        child: Scaffold(
      extendBodyBehindAppBar: false,
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        backgroundColor: Colors.transparent,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [StdAppName()]),
      ),
      body: PageView(
        controller: _destinationPagesController,
        physics: const NeverScrollableScrollPhysics(),
        children: _getDestinationPages(),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: _getBottomNavThemeData(),
        child: NavigationBar(
          animationDuration: const Duration(seconds: 2),
          selectedIndex: _getSelectedIndex(),
          destinations: _getDestinations(),
          onDestinationSelected: _switchDestination,
        ),
      ),
    ));
  }

  List<NavigationDestination> _getDestinations() {
    return [
      const NavigationDestination(
          icon: Icon(Icons.local_fire_department_outlined),
          label: homeDestinationLbl),
      const NavigationDestination(
          icon: Icon(Icons.local_fire_department_rounded),
          label: myMatchesDestinationLbl),
      const NavigationDestination(
          icon: Icon(Icons.account_circle_outlined),
          label: myProfileDestinationLbl),
    ];
  }

  NavigationBarThemeData _getBottomNavThemeData() {
    return NavigationBarThemeData(
        iconTheme: MaterialStateProperty.resolveWith((states) {
          return (states.contains(MaterialState.selected))
              ? IconThemeData(color: appTheme.colorScheme.primary, size: 32)
              : const IconThemeData(color: Colors.black, size: 24);
        }),
        labelTextStyle: MaterialStateProperty.resolveWith((states) => (states
                .contains(MaterialState.selected))
            ? appTextTheme.button?.copyWith(color: appTheme.colorScheme.primary)
            : appTextTheme.button?.copyWith(color: Colors.black54)),
        elevation: paddingStd,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected);
  }

  _getSelectedIndex() {
    switch (_homeDestinations) {
      case HomeDestinations.matching:
        return 0;
      case HomeDestinations.matched:
        return 1;
      case HomeDestinations.profile:
        return 2;
    }
  }

  void _switchDestination(int index) {
    if (index == 0) {
      setState(() {
        _homeDestinations = HomeDestinations.matching;
        _destinationPagesController.jumpToPage(_getSelectedIndex());
      });
    }

    if (index == 1) {
      setState(() {
        _homeDestinations = HomeDestinations.matched;
        _destinationPagesController.jumpToPage(_getSelectedIndex());
      });
    }

    if (index == 2) {
      setState(() {
        _homeDestinations = HomeDestinations.profile;
        _destinationPagesController.jumpToPage(_getSelectedIndex());
      });
    }
  }

  List<Widget> _getDestinationPages() {
    return _destinationScreens
        .map((pageScreen) => _getDestinationScreenContainer(pageScreen))
        .toList(growable: false);
  }

  Widget _getDestinationScreenContainer(Widget screen) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
            decoration: BoxDecoration(gradient: threeColorOpaqueGradientTB),
            constraints:
                BoxConstraints(minWidth: screenWidth, minHeight: screenHeight),
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: paddingMd, horizontal: paddingStd),
                child: screen)));
  }
}

enum HomeDestinations { matching, matched, profile }

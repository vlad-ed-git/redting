import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/core/components/screens/screen_container.dart';
import 'package:redting/core/components/text/app_name_std_style.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/dating_profile/presentation/state/dating_profile_bloc.dart';
import 'package:redting/res/dimens.dart';

class CreateDatingProfileScreen extends StatefulWidget {
  const CreateDatingProfileScreen({Key? key}) : super(key: key);

  @override
  State<CreateDatingProfileScreen> createState() =>
      _CreateDatingProfileScreenState();
}

class _CreateDatingProfileScreenState extends State<CreateDatingProfileScreen> {
  late AuthUser loggedInUser;
  @override
  Widget build(BuildContext context) {
    RouteSettings? settings = ModalRoute.of(context)?.settings;
    if (settings != null && settings.arguments is AuthUser) {
      loggedInUser = settings.arguments as AuthUser;
    }

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
        lazy: false,
        create: (BuildContext blocProviderContext) =>
            GetIt.instance<DatingProfileBloc>(),
        child: BlocListener<DatingProfileBloc, DatingProfileState>(
            listener: _listenToStateChange,
            child: BlocBuilder<DatingProfileBloc, DatingProfileState>(
                builder: (blocContext, state) {
              if (state is DatingProfileInitialState) {
                _onInitState(blocContext);
              }

              return ScreenContainer(
                  child: Scaffold(
                      extendBodyBehindAppBar: true,
                      appBar: AppBar(
                        toolbarHeight: appBarHeight,
                        backgroundColor: Colors.transparent,
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [StdAppName()]),
                      ),
                      body: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: threeColorOpaqueGradientTB),
                          constraints: BoxConstraints(
                              minWidth: screenWidth, minHeight: screenHeight),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: (appBarHeight * 1.5),
                            ),
                            child: ListBody(
                              children: [Text(" WELCOME ")],
                            ),
                          ),
                        ),
                      )));
            })));
  }

  void _listenToStateChange(BuildContext context, DatingProfileState state) {}

  void _onInitState(BuildContext blocContext) {}
}

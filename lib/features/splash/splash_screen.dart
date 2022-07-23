import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/cards/glass_card.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/core/components/screens/screen_container.dart';
import 'package:redting/core/components/text/app_name_std_style.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/splash/state/current_user_bloc.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/routes.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return BlocProvider(
      lazy: false,
      create: (BuildContext blocProviderContext) =>
          GetIt.instance<CurrentUserBloc>(),
      child: BlocListener<CurrentUserBloc, CurrentUserState>(
        listener: (context, state) {
          if (state is LoadedCurrentUserState) {
            bool shouldLogin = state.authUser == null;
            bool shouldCreateProfile =
                state.authUser != null && state.userProfile == null;
            bool shouldCreateDatingProfile = state.authUser != null &&
                state.userProfile != null &&
                state.datingProfile == null;
            bool shouldGoHome = state.authUser != null &&
                state.userProfile != null &&
                state.datingProfile != null;

            if (shouldLogin) {
              _goToLogin();
            }

            if (shouldCreateProfile) {
              print(state.userProfile);
              _goToProfileScreen(authUser: state.authUser!);
            }

            if (shouldCreateDatingProfile) {
              _goToDatingProfile(authUser: state.authUser!);
            }

            if (shouldGoHome) {
              _goToHome();
            }
          }
        },
        child: ScreenContainer(
            child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            constraints:
                BoxConstraints(minHeight: screenHeight, minWidth: screenWidth),
            decoration: BoxDecoration(gradient: fiveColorOpaqueGradient),
            child: Padding(
                padding: const EdgeInsets.all(paddingMd),
                child: GlassCard(
                  constraints: const BoxConstraints(
                      minWidth: 300, maxWidth: 300, minHeight: 200),
                  child: BlocBuilder<CurrentUserBloc, CurrentUserState>(
                      builder: (blocContext, state) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: paddingMd),
                            child: const StdAppName(
                              large: true,
                            ),
                          ),
                          if (state is InitialState) _initialize(blocContext),
                          if (state is LoadingCurrentUserState)
                            _getLoadingIndicator(),
                          if (state is ErrorLoadingCurrentUserState)
                            _errorWidget(),
                        ]);
                  }),
                )),
          ),
        )),
      ),
    );
  }

  Widget _initialize(BuildContext blocContext) {
    BlocProvider.of<CurrentUserBloc>(blocContext).add(LoadCurrentUserEvent());
    return Center(
      child: Text(
        loadingAuthUser,
        style: appTextTheme.bodyText1
            ?.copyWith(color: appTheme.colorScheme.primary),
      ),
    );
  }

  Widget _getLoadingIndicator() {
    return const Center(
      child: CircularProgress(),
    );
  }

  Widget _errorWidget() {
    return Center(
      child: Text(
        loadingAuthUserErr,
        style: appTextTheme.bodyText1?.copyWith(
          color: appTheme.colorScheme.error,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  //navigation
  void _goToLogin() {
    Navigator.pushReplacementNamed(context, loginRoute);
  }

  void _goToProfileScreen({required AuthUser authUser}) {
    Navigator.pushReplacementNamed(context, createProfileRoute,
        arguments: authUser);
  }

  void _goToHome() {
    Navigator.pushReplacementNamed(context, homeRoute);
  }

  void _goToDatingProfile({required AuthUser authUser}) {
    Navigator.pushReplacementNamed(context, createDatingProfileRoute,
        arguments: authUser);
  }
}

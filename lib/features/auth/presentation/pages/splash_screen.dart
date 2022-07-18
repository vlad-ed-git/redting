import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/cards/glass_card.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/core/components/screens/screen_container.dart';
import 'package:redting/core/components/text/app_name_std_style.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/auth/presentation/state/auth_user_bloc.dart';
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
          GetIt.instance<AuthUserBloc>(),
      child: BlocListener<AuthUserBloc, AuthUserState>(
        listener: (context, state) {
          if (state is UserSignedInState) {
            _goToProfileScreen(authUser: state.authUser);
          }
          if (state is NoAuthUserFoundState) {
            _goToLogin();
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
                  child: BlocBuilder<AuthUserBloc, AuthUserState>(
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
                          if (state is InitialAuthUserState)
                            _initialize(blocContext),
                          if (state is LoadingAuthState) _getLoadingIndicator(),
                          if (state is ErrorLoadingAuthUserState)
                            _getErrorTxt(),
                        ]);
                  }),
                )),
          ),
        )),
      ),
    );
  }

  Widget _initialize(BuildContext blocContext) {
    BlocProvider.of<AuthUserBloc>(blocContext).add(LoadAuthUserEvent());
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

  Widget _getErrorTxt() {
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
  _goToLogin() {
    Navigator.pushReplacementNamed(context, loginRoute);
  }

  _goToProfileScreen({required AuthUser authUser}) {
    Navigator.pushReplacementNamed(context, createProfileRoute,
        arguments: authUser);
  }
}

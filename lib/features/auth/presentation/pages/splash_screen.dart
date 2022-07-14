import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redting/core/components/cards/glass_card.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/core/components/screens/screen_container.dart';
import 'package:redting/core/components/text/app_name_std_style.dart';
import 'package:redting/features/auth/di/auth_di.dart';
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
    return BlocProvider(
      lazy: false,
      create: (BuildContext blocProviderContext) =>
          authDiInstance<AuthUserBloc>(),
      child: BlocListener<AuthUserBloc, AuthUserState>(
        listener: (context, state) {
          if (state is LoadedAuthUserState) _goToHome();
          if (state is NoAuthUserFoundState) _goToLogin();
        },
        child: ScreenContainer(
            child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
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
                          if (state is LoadingAuthUserState)
                            _getLoadingIndicator(),
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
    return Center(
      child: CircularProgressIndicator(
        color: appTheme.colorScheme.primary,
        backgroundColor: appTheme.colorScheme.primaryContainer,
      ),
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
    Navigator.pushNamed(context, loginRoute);
  }

  _goToHome() {
    //todo navigate away
  }
}

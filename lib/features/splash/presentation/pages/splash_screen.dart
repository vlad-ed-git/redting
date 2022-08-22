import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/core/components/screens/scaffold_wrapper.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/splash/presentation/state/current_user_bloc.dart';
import 'package:redting/res/assets_paths.dart';
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
                state.userProfile?.datingPhotos.isEmpty == true;

            bool shouldGoHome = state.authUser != null &&
                state.userProfile != null &&
                state.userProfile?.datingPhotos.isNotEmpty == true;

            if (shouldLogin) {
              _goToLogin();
            }

            if (shouldCreateProfile) {
              _goToProfileScreen(authUser: state.authUser!);
            }

            if (shouldCreateDatingProfile) {
              _goToDatingProfile(profile: state.userProfile!);
            }

            if (shouldGoHome) {
              _goToHome(profile: state.userProfile!);
            }
          }
        },
        child: ScaffoldWrapper(
            child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: BoxDecoration(gradient: twoColorOpaquePrimaryGradient),
            constraints:
                BoxConstraints(minWidth: screenWidth, minHeight: screenHeight),
            child: BlocBuilder<CurrentUserBloc, CurrentUserState>(
                builder: (blocContext, state) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: paddingMd),
                      child: Image.asset(
                        redLogoPath,
                        height: 56,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    if (state is InitialState) _initialize(blocContext),
                    if (state is LoadingCurrentUserState)
                      _getLoadingIndicator(),
                    if (state is ErrorLoadingCurrentUserState) _errorWidget(),
                  ]);
            }),
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

  void _goToDatingProfile({required UserProfile profile}) {
    Navigator.pushReplacementNamed(context, addDatingProfileRoute,
        arguments: profile);
  }

  void _goToHome({required UserProfile profile}) {
    Navigator.pushReplacementNamed(context, homeRoute, arguments: profile);
  }
}

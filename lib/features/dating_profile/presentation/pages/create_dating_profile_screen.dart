import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/buttons/main_elevated_btn.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/core/components/screens/screen_container.dart';
import 'package:redting/core/components/text/app_name_std_style.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/dating_profile/presentation/components/age_preference_slider.dart';
import 'package:redting/features/dating_profile/presentation/components/dating_pics.dart';
import 'package:redting/features/dating_profile/presentation/components/gender_preferences.dart';
import 'package:redting/features/dating_profile/presentation/components/sexual_preferences.dart';
import 'package:redting/features/dating_profile/presentation/state/dating_profile_bloc.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class CreateDatingProfileScreen extends StatefulWidget {
  const CreateDatingProfileScreen({Key? key}) : super(key: key);

  @override
  State<CreateDatingProfileScreen> createState() =>
      _CreateDatingProfileScreenState();
}

class _CreateDatingProfileScreenState extends State<CreateDatingProfileScreen> {
  late AuthUser loggedInUser;
  bool _isSavingProfile = false;

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
                      extendBodyBehindAppBar: false,
                      appBar: AppBar(
                        toolbarHeight: appBarHeight,
                        backgroundColor: appTheme.colorScheme.primary,
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              StdAppName(
                                firstPartTxtColor: Colors.white,
                                secondPartTxtColor:
                                    appTheme.colorScheme.inversePrimary,
                              )
                            ]),
                      ),
                      body: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: threeColorOpaqueGradientTB),
                          constraints: BoxConstraints(
                              minWidth: screenWidth, minHeight: screenHeight),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: paddingMd, horizontal: paddingStd),
                            child: ListBody(
                              children: [
                                DatingPicsWidget(),
                                const SizedBox(
                                  height: paddingMd,
                                ),
                                AgePreferenceSlider(),
                                const SizedBox(
                                  height: paddingMd,
                                ),
                                GenderPreferences(),
                                const SizedBox(
                                  height: paddingMd,
                                ),
                                SexualPreferences(),
                                const SizedBox(
                                  height: paddingMd,
                                ),
                                MainElevatedBtn(
                                    onPressed: () {},
                                    showLoading: _isSavingProfile,
                                    lbl: createDatingProfileBtn)
                              ],
                            ),
                          ),
                        ),
                      )));
            })));
  }

  void _listenToStateChange(BuildContext context, DatingProfileState state) {}

  void _onInitState(BuildContext blocContext) {}
}

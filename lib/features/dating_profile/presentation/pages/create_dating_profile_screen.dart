import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/buttons/main_elevated_btn.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/core/components/screens/screen_container.dart';
import 'package:redting/core/components/snack/snack.dart';
import 'package:redting/core/components/text/app_name_std_style.dart';
import 'package:redting/core/utils/consts.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/dating_profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/dating_profile/presentation/components/age_preference_slider.dart';
import 'package:redting/features/dating_profile/presentation/components/dating_pics.dart';
import 'package:redting/features/dating_profile/presentation/components/gender_preferences.dart';
import 'package:redting/features/dating_profile/presentation/components/sexual_preferences.dart';
import 'package:redting/features/dating_profile/presentation/state/dating_profile_bloc.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/routes.dart';
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
  List<File> _datingPicsFiles = [];
  List<String> _datingPicsFileNames = [];
  int _minAge = 18, _maxAge = 60;
  UserGender? _myGenderPreference;
  List<SexualOrientation> _mySexualOrientationPreferences = [];
  bool _makeMyOrientationPublic = true;
  bool _showMeMyOrientationOnly = true;
  DatingProfileBloc? _eventDispatcher;

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
                              Expanded(
                                  child: StdAppName(
                                firstPartTxtColor: Colors.white,
                                secondPartTxtColor:
                                    appTheme.colorScheme.inversePrimary,
                              )),
                              const SizedBox(
                                width: paddingStd,
                              ),
                              IconButton(
                                  iconSize: 32,
                                  onPressed: () {
                                    _onSaveProfile(blocContext);
                                  },
                                  icon: const Icon(
                                    Icons.check_circle,
                                    size: 32,
                                    color: Colors.white,
                                  ))
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
                                DatingPicsWidget(
                                  onError: (String errMsg) {
                                    _showSnack(errMsg);
                                  },
                                  onRemoveFile: _onRemovePhoto,
                                  onChange: _onAddPhoto,
                                  imageFile: _datingPicsFiles,
                                  disableClick: _isSavingProfile,
                                ),
                                const SizedBox(
                                  height: paddingMd,
                                ),
                                AgePreferenceSlider(
                                  fromAge: _minAge.toDouble(),
                                  toAge: _maxAge.toDouble(),
                                  onAgeRangeSet: (int from, int to) {
                                    if (mounted) {
                                      setState(() {
                                        _minAge = from;
                                        _maxAge = to;
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: paddingMd,
                                ),
                                GenderPreferences(
                                  onChangeGender: (UserGender? value) {
                                    if (mounted) {
                                      setState(() {
                                        _myGenderPreference = value;
                                      });
                                    }
                                  },
                                  initialGender: _myGenderPreference,
                                ),
                                const SizedBox(
                                  height: paddingMd,
                                ),
                                SexualPreferences(
                                  orientationPreferences:
                                      _mySexualOrientationPreferences,
                                  onUpdatedPreferences: (List<SexualOrientation>
                                      orientationPreferences) {
                                    if (mounted) {
                                      setState(() {
                                        _mySexualOrientationPreferences =
                                            orientationPreferences;
                                      });
                                    }
                                  },
                                  onUpdateVisibility:
                                      (bool isSexOrientationPublic) {
                                    if (mounted) {
                                      setState(() {
                                        _makeMyOrientationPublic =
                                            isSexOrientationPublic;
                                      });
                                    }
                                  },
                                  onUpdateRestrictions:
                                      (bool onlySimilarSexOrientation) {
                                    if (mounted) {
                                      setState(() {
                                        _showMeMyOrientationOnly =
                                            onlySimilarSexOrientation;
                                      });
                                    }
                                  },
                                  makeMyOrientationPublic:
                                      _makeMyOrientationPublic,
                                  showMeMyOrientationOnly:
                                      _showMeMyOrientationOnly,
                                ),
                                const SizedBox(
                                  height: paddingMd,
                                ),
                                Center(
                                  child: Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 200),
                                    child: MainElevatedBtn(
                                      onPressed: () {
                                        _onSaveProfile(blocContext);
                                      },
                                      showLoading: _isSavingProfile,
                                      lbl: createDatingProfileBtn,
                                      loadingLbl:
                                          creatingDatingProfilePleaseWait,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )));
            })));
  }

  void _listenToStateChange(BuildContext context, DatingProfileState state) {
    if (state is CreatingProfileState) {
      if (mounted) {
        setState(() {
          _isSavingProfile = true;
        });
      }
    }

    if (state is CreatedProfileState) {
      if (mounted) {
        setState(() {
          _isSavingProfile = false;
        });
      }
      Navigator.pushReplacementNamed(context, splashRoute);
    }

    if (state is CreatingProfileFailedState) {
      if (mounted) {
        setState(() {
          _isSavingProfile = false;
        });
        _showSnack(state.errMsg);
      }
    }
  }

  void _onInitState(BuildContext blocContext) {}

  /// EVENTS
  void _onSaveProfile(BuildContext blocContext) {
    if (_isSavingProfile) return;
    if (_datingPicsFiles.length < minDatingProfilePhotosAllowed) {
      _showSnack(datingProfilePicsMissingErr);
      return;
    }
    _eventDispatcher ??= BlocProvider.of<DatingProfileBloc>(blocContext);
    _eventDispatcher?.add(CreateProfileEvent(
      loggedInUser.userId,
      _datingPicsFiles,
      _minAge,
      _maxAge,
      _myGenderPreference,
      _mySexualOrientationPreferences,
      _makeMyOrientationPublic,
      _showMeMyOrientationOnly,
      _datingPicsFileNames,
    ));
  }

  _onAddPhoto(File newFile, String filename, int photoNum) {
    if (photoNum < maxDatingProfilePhotos) {
      if (_datingPicsFiles.length > photoNum) {
        _datingPicsFiles[photoNum] = newFile;
        _datingPicsFileNames[photoNum] = filename;
      } else {
        _datingPicsFiles.add(newFile);
        _datingPicsFileNames.add(filename);
      }
    }
    if (mounted) {
      setState(() {
        _datingPicsFiles = _datingPicsFiles;
        _datingPicsFileNames = _datingPicsFileNames;
      });
    }
  }

  _onRemovePhoto(int pos) {
    if (_datingPicsFiles.length > pos) {
      _datingPicsFiles.removeAt(pos);
      _datingPicsFileNames.removeAt(pos);
    }
    if (mounted) {
      setState(() {
        _datingPicsFiles = _datingPicsFiles;
        _datingPicsFileNames = _datingPicsFileNames;
      });
    }
  }

  /// SNACK
  void _showSnack(String err, {bool isError = true}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(Snack(
        content: err,
        isError: isError,
      ).create(context));
    }
  }
}

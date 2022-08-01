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
import 'package:redting/features/profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/presentation/components/age_preference_slider.dart';
import 'package:redting/features/profile/presentation/components/dating_pics.dart';
import 'package:redting/features/profile/presentation/components/gender_preferences.dart';
import 'package:redting/features/profile/presentation/components/sexual_preferences.dart';
import 'package:redting/features/profile/presentation/state/user_profile_bloc.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/routes.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class AddDatingInfoScreen extends StatefulWidget {
  const AddDatingInfoScreen({Key? key}) : super(key: key);

  @override
  State<AddDatingInfoScreen> createState() => _AddDatingInfoScreenState();
}

class _AddDatingInfoScreenState extends State<AddDatingInfoScreen> {
  late UserProfile userProfile;
  bool _isSavingProfile = false;
  List<File> _datingPicsFiles = [];
  List<String> _datingPicsFileNames = [];
  int _minAge = 18, _maxAge = 60;
  UserGender? _myGenderPreference;
  List<SexualOrientation> _mySexualOrientationPreferences = [
    SexualOrientation.straight
  ];
  bool _makeMyOrientationPublic = false;
  bool _showMeMyOrientationOnly = false;
  UserProfileBloc? _eventDispatcher;

  @override
  Widget build(BuildContext context) {
    RouteSettings? settings = ModalRoute.of(context)?.settings;
    if (settings != null && settings.arguments is UserProfile) {
      userProfile = settings.arguments as UserProfile;
      _makeMyOrientationPublic = userProfile.makeMyOrientationPublic;
      _showMeMyOrientationOnly = userProfile.onlyShowMeOthersOfSameOrientation;
      _myGenderPreference = userProfile.getGender() == UserGender.male
          ? UserGender.female
          : (userProfile.getGender() == UserGender.female)
              ? UserGender.male
              : null;
    }

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
        lazy: false,
        create: (BuildContext blocProviderContext) =>
            GetIt.instance<UserProfileBloc>(),
        child: BlocListener<UserProfileBloc, UserProfileState>(
            listener: _listenToStateChange,
            child: BlocBuilder<UserProfileBloc, UserProfileState>(
                builder: (blocContext, state) {
              if (state is UserProfileInitialState) {
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
                                Text(datingPicsHint,
                                    style: appTextTheme.bodyText1?.copyWith(
                                        color: appTheme.colorScheme.primary)),
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
                                      flipColors: true,
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

  void _listenToStateChange(BuildContext context, UserProfileState state) {
    if (state is AddingDatingInfoState) {
      if (mounted) {
        setState(() {
          _isSavingProfile = true;
        });
      }
    }

    if (state is AddedDatingInfoState) {
      if (mounted) {
        setState(() {
          _isSavingProfile = false;
        });
      }
      Navigator.pushReplacementNamed(context, splashRoute);
    }

    if (state is AddingDatingInfoFailedState) {
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
    _eventDispatcher ??= BlocProvider.of<UserProfileBloc>(blocContext);
    _eventDispatcher?.add(AddDatingInfoEvent(
      userProfile,
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

  @override
  void dispose() {
    _eventDispatcher?.close();
    super.dispose();
  }
}

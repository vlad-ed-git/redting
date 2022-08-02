import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/buttons/main_elevated_btn.dart';
import 'package:redting/core/components/snack/snack.dart';
import 'package:redting/core/utils/consts.dart';
import 'package:redting/features/profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/domain/utils/dating_pic.dart';
import 'package:redting/features/profile/presentation/components/age_preference_slider.dart';
import 'package:redting/features/profile/presentation/components/dating_pics.dart';
import 'package:redting/features/profile/presentation/components/gender_preferences.dart';
import 'package:redting/features/profile/presentation/components/screen_containers/edit_profile_container.dart';
import 'package:redting/features/profile/presentation/components/sexual_preferences.dart';
import 'package:redting/features/profile/presentation/state/user_profile_bloc.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/routes.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class EditDatingInfoScreen extends StatefulWidget {
  final UserProfile userProfile;
  const EditDatingInfoScreen({Key? key, required this.userProfile})
      : super(key: key);

  @override
  State<EditDatingInfoScreen> createState() => _EditDatingInfoScreenState();
}

class _EditDatingInfoScreenState extends State<EditDatingInfoScreen> {
  bool _isSavingProfile = false;
  List<DatingPic> _datingPics = [];
  late int _minAge, _maxAge;
  UserGender? _myGenderPreference;
  late List<SexualOrientation> _mySexualOrientationPreferences;
  late bool _makeMyOrientationPublic, _showMeMyOrientationOnly;
  UserProfileBloc? _eventDispatcher;

  @override
  void initState() {
    _makeMyOrientationPublic = widget.userProfile.makeMyOrientationPublic;
    _showMeMyOrientationOnly =
        widget.userProfile.onlyShowMeOthersOfSameOrientation;
    _myGenderPreference = widget.userProfile.getGenderPreferences() ??
        (widget.userProfile.getGender() == UserGender.male
            ? UserGender.female
            : (widget.userProfile.getGender() == UserGender.female)
                ? UserGender.male
                : null);

    final usersDatingPics = widget.userProfile.datingPhotos;
    for (int i = 0; i < maxDatingProfilePhotos; i++) {
      if (usersDatingPics.length > i) {
        String photoUrl = usersDatingPics[i];
        _datingPics.add(DatingPic(position: i, photoUrl: photoUrl));
      }
    }
    _minAge = widget.userProfile.minAgePreference;
    _maxAge = widget.userProfile.maxAgePreference;
    _mySexualOrientationPreferences =
        widget.userProfile.getUserSexualOrientation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

              return EditProfileContainer(
                  onSaveProfile: () {
                    _onSaveProfile(blocContext);
                  },
                  child: ListBody(
                    children: [
                      Text(datingPicsHint,
                          style: appTextTheme.bodyText1
                              ?.copyWith(color: appTheme.colorScheme.primary)),
                      DatingPicsWidget(
                        onError: (String errMsg) {
                          _showSnack(errMsg);
                        },
                        onRemoveFile: _onRemovePhoto,
                        onChange: _onAddPhoto,
                        datingPics: _datingPics,
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
                        orientationPreferences: _mySexualOrientationPreferences,
                        onUpdatedPreferences:
                            (List<SexualOrientation> orientationPreferences) {
                          if (mounted) {
                            setState(() {
                              _mySexualOrientationPreferences =
                                  orientationPreferences;
                            });
                          }
                        },
                        onUpdateVisibility: (bool isSexOrientationPublic) {
                          if (mounted) {
                            setState(() {
                              _makeMyOrientationPublic = isSexOrientationPublic;
                            });
                          }
                        },
                        onUpdateRestrictions: (bool onlySimilarSexOrientation) {
                          if (mounted) {
                            setState(() {
                              _showMeMyOrientationOnly =
                                  onlySimilarSexOrientation;
                            });
                          }
                        },
                        makeMyOrientationPublic: _makeMyOrientationPublic,
                        showMeMyOrientationOnly: _showMeMyOrientationOnly,
                      ),
                      const SizedBox(
                        height: paddingMd,
                      ),
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: MainElevatedBtn(
                            onPressed: () {
                              _onSaveProfile(blocContext);
                            },
                            primaryBg: true,
                            showLoading: _isSavingProfile,
                            lbl: createDatingProfileBtn,
                            loadingLbl: creatingDatingProfilePleaseWait,
                          ),
                        ),
                      )
                    ],
                  ));
            })));
  }

  void _listenToStateChange(BuildContext context, UserProfileState state) {
    if (state is SettingDatingInfoState) {
      if (mounted) {
        setState(() {
          _isSavingProfile = true;
        });
      }
    }

    if (state is SetDatingInfoState) {
      if (mounted) {
        setState(() {
          _isSavingProfile = false;
        });
      }
      _showSnack(updateProfileSuccess, isError: false);
      Navigator.pushReplacementNamed(context, homeRoute,
          arguments: state.profile);
    }

    if (state is SettingDatingInfoFailedState) {
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
    _eventDispatcher ??= BlocProvider.of<UserProfileBloc>(blocContext);
    _eventDispatcher?.add(SetDatingInfoEvent(
      widget.userProfile,
      _datingPics,
      _minAge,
      _maxAge,
      _myGenderPreference,
      _mySexualOrientationPreferences,
      _makeMyOrientationPublic,
      _showMeMyOrientationOnly,
    ));
  }

  _onAddPhoto(File newFile, String filename, int photoNum) {
    if (photoNum < maxDatingProfilePhotos) {
      if (_datingPics.length > photoNum) {
        _datingPics[photoNum].fileName = filename;
        _datingPics[photoNum].file = newFile;
      } else {
        _datingPics.add(
            DatingPic(position: photoNum, file: newFile, fileName: filename));
      }
    }
    if (mounted) {
      setState(() {
        _datingPics = _datingPics;
      });
    }
  }

  _onRemovePhoto(int photoNum) {
    if (photoNum < maxDatingProfilePhotos) {
      if (_datingPics.length > photoNum) {
        _datingPics[photoNum].fileName = null;
        _datingPics[photoNum].file = null;
        _datingPics[photoNum].photoUrl = null;
      } else {
        _datingPics.add(DatingPic(
          position: photoNum,
        ));
      }
    }
    if (mounted) {
      setState(() {
        _datingPics = _datingPics;
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

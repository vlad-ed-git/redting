import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/core/components/screens/screen_container.dart';
import 'package:redting/core/components/snack/snack.dart';
import 'package:redting/core/components/text/app_name_std_style.dart';
import 'package:redting/core/components/text_input/unstyled_input_txt.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/presentation/components/profile_photo.dart';
import 'package:redting/features/profile/presentation/components/verification_video.dart';
import 'package:redting/features/profile/presentation/state/user_profile_bloc.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({Key? key}) : super(key: key);

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  late AuthUser loggedInUser;
  late TextEditingController _nameController,
      _titleController,
      _bioController,
      _otherGenderController,
      _bDayController;
  UserGender _gender = UserGender.stated;
  String? _otherGender;

  bool _isDialogOpen = false;

  //birthday stuff
  final DateTime today = DateTime.now();
  final int eighteenYears = 365 * 18;
  final int twentyFourYears = 365 * 24;
  final int hundredTwentyYears = 365 * 120;

  //PROFILE PHOTO
  String? _profilePhoto;
  File? _selectedLocalPhotoFile;
  bool _isUploadingPhoto = false;

  //VERIFICATION VIDEO
  String? _verificationCode;
  bool _loadingVerificationCode = false;
  bool _isUploadingVideo = false;
  String? _profileVerificationVideo;
  File? _createdLocalVideoFile;

  @override
  void initState() {
    _nameController = TextEditingController();
    _titleController = TextEditingController();
    _bioController = TextEditingController();
    _otherGenderController = TextEditingController();
    _bDayController = TextEditingController();
    super.initState();
  }

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
                              children: [
                                Container(
                                  decoration: _getTopHalfDecor(
                                      screenHeight, screenWidth),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: paddingMd, bottom: paddingLg),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ProfilePhoto(
                                          isLoading: _isUploadingPhoto,
                                          profilePhoto: _profilePhoto,
                                          localPhoto: _selectedLocalPhotoFile,
                                          onError: (String err) {
                                            _showSnack(err);
                                          },
                                          onChange:
                                              (File? file, String? filename) {
                                            _onNewProfileImage(
                                                file, filename, blocContext);
                                          },
                                        ),
                                        const SizedBox(
                                          height: paddingSm,
                                        ),
                                        UnStyledTxtInput(
                                          controller: _nameController,
                                          keyboardType: TextInputType.name,
                                          hint: nameHint,
                                          constraints: const BoxConstraints(
                                              maxWidth: 200),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: paddingStd,
                                        ),
                                        VerificationVideo(
                                          onCameraError: (String err) {
                                            _showSnack(err);
                                          },
                                          loadingVerificationCode:
                                              _loadingVerificationCode,
                                          isUploadingVideo: _isUploadingVideo,
                                          verificationCode: _verificationCode,
                                          localVideoFile:
                                              _createdLocalVideoFile,
                                          profileVerificationVideo:
                                              _profileVerificationVideo,
                                          onChanged:
                                              (File? createdLocalVideoFile) {
                                            _onNewVerificationVideo(
                                                createdLocalVideoFile,
                                                blocContext);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: paddingMd),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      UnStyledTxtInput(
                                        controller: _titleController,
                                        hint: titleHint,
                                        label: titleLbl,
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(
                                        height: paddingStd,
                                      ),
                                      UnStyledTxtInput(
                                        controller: _bioController,
                                        hint: bioHint,
                                        label: bioLbl,
                                        maxCharacters: 120,
                                        keyboardType: TextInputType.multiline,
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(
                                        height: paddingStd,
                                      ),
                                      Text(
                                        gender,
                                        style: appTextTheme.subtitle2
                                            ?.copyWith(color: Colors.black45),
                                      ),
                                      const SizedBox(
                                        height: paddingStd,
                                      ),
                                      _getGenderWidgets(),
                                      const SizedBox(
                                        height: paddingStd,
                                      ),
                                      _getBirthdayPicker(),
                                      const SizedBox(
                                        height: paddingStd,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )));
            })));
  }

  /// STATE CHANGE
  void _onInitState(BuildContext blocContext) {
    //get the verification code asap
    UserProfileBloc event = BlocProvider.of<UserProfileBloc>(blocContext);
    event.add(GetVerificationVideoCodeEvent());
  }

  void _listenToStateChange(BuildContext context, UserProfileState state) {
    /// PROFILE PHOTO
    if (state is UpdatingProfilePhotoState) {
      setState(() {
        _isUploadingPhoto = true;
      });
    }
    if (state is UpdatedProfilePhotoState) {
      setState(() {
        _isUploadingPhoto = false;
        _profilePhoto = state.photoUrl;
        _showSnack(uploadingPhotoSuccess, isError: false);
      });
    }
    if (state is UpdatingProfilePhotoFailedState) {
      setState(() {
        _isUploadingPhoto = false;
        _profilePhoto = null;
        _selectedLocalPhotoFile = null;
        _showSnack(state.errMsg);
      });
    }

    /// VERIFICATION VIDEO CODE
    if (state is LoadingVerificationVideoCodeState) {
      setState(() {
        _loadingVerificationCode = true;
      });
    }

    if (state is LoadedVerificationVideoCodeState) {
      setState(() {
        _verificationCode = state.verificationVideoCode;
        _loadingVerificationCode = false;
      });
    }

    if (state is LoadingVerificationVideoCodeFailedState) {
      setState(() {
        _showSnack(state.errMsg);
      });
    }

    /// VERIFICATION VIDEO
    if (state is UpdatingVerificationVideoState) {
      setState(() {
        _isUploadingVideo = true;
      });
    }

    if (state is UpdatedVerificationVideoState) {
      setState(() {
        _isUploadingVideo = false;
        _profileVerificationVideo = state.videoUrl;
        _showSnack(uploadingVerificationVideSuccess, isError: false);
      });
    }

    if (state is UpdatingVerificationVideoFailedState) {
      setState(() {
        _isUploadingVideo = false;
        _profileVerificationVideo = null;
        _createdLocalVideoFile = null;
        _showSnack(state.errMsg);
      });
    }
  }

  /// EVENTS
  void _onNewProfileImage(
      File? file, String? filename, BuildContext blocContext) {
    if (_isUploadingPhoto || file == null || filename == null) return;
    setState(() {
      _selectedLocalPhotoFile = file;
    });
    UserProfileBloc event = BlocProvider.of<UserProfileBloc>(blocContext);
    event.add(ChangeProfilePhotoEvent(file, filename));
  }

  void _onNewVerificationVideo(File? file, BuildContext blocContext) {
    if (_isUploadingVideo || file == null) return;
    setState(() {
      _createdLocalVideoFile = file;
    });
    UserProfileBloc event = BlocProvider.of<UserProfileBloc>(blocContext);
    event.add(ChangeVerificationVideoEvent(file));
  }

  /// GENDER
  Widget _getGenderWidgets() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _getGender(value: UserGender.female, lbl: femaleGender),
        const VerticalDivider(
          width: paddingStd,
        ),
        _getGender(value: UserGender.male, lbl: maleGender),
        const VerticalDivider(
          width: paddingStd,
        ),
        Expanded(
            child: UnStyledTxtInput(
          controller: _otherGenderController,
          hint: otherGenderHint,
          onTxtChanged: _onGenderTyped,
        ))
      ],
    );
  }

  Widget _getGender({required UserGender value, required String lbl}) {
    return InkWell(
      splashColor: appTheme.colorScheme.secondary.withOpacity(0.1),
      radius: 8.0,
      borderRadius: BorderRadius.circular(8.0),
      onTap: () {
        setState(() {
          _gender = value;
          _otherGenderController.clear();
          _otherGender = null;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: _gender == value
                    ? appTheme.colorScheme.primary
                    : Colors.black26,
                width: 1.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            lbl,
            style: appTextTheme.headline6,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  _onGenderTyped(String other) {
    setState(() {
      _gender = UserGender.stated;
      _otherGender = other;
    });
  }

  /// BIRTHDAY
  Widget _getBirthdayPicker() {
    return UnStyledTxtInput(
      onTap: () {
        _showBDatePickerDialog();
      },
      controller: _bDayController,
      hint: birthDay,
      keyboardType: TextInputType.none,
      label: birthDay,
    );
  }

  void _showBDatePickerDialog() async {
    if (_isDialogOpen) return;
    setState(() {
      _isDialogOpen = true;
    });
    DateTime eighteenYearsAgo = today.subtract(Duration(days: eighteenYears));
    DateTime hundredTwentyYearsBefore =
        today.subtract(Duration(days: hundredTwentyYears));
    DateTime twentyFourYearsAgo =
        today.subtract(Duration(days: twentyFourYears));

    DateTime? selectedBDay = await showDatePicker(
        context: context,
        initialDate: twentyFourYearsAgo,
        firstDate: hundredTwentyYearsBefore,
        lastDate: eighteenYearsAgo);

    if (mounted) {
      setState(() {
        _isDialogOpen = false;
        if (selectedBDay != null) {
          _bDayController.text =
              "${selectedBDay.year} / ${selectedBDay.month} / ${selectedBDay.day} ";
        }
      });
    }
  }

  /// DECOR
  _getTopHalfDecor(double screenHeight, double screenWidth) {
    return BoxDecoration(
      boxShadow: const [
        BoxShadow(
            offset: Offset(0.0, 3.0),
            color: Colors.black26,
            blurRadius: 12,
            spreadRadius: 2)
      ],
      color: appTheme.colorScheme.primaryContainer,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(screenWidth / 2),
        bottomRight: Radius.circular(screenWidth / 2),
      ),
    );
  }

  /// snack
  void _showSnack(String err, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(Snack(
      content: err,
      isError: isError,
    ).create(context));
  }
}

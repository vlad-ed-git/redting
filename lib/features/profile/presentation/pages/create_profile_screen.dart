import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/buttons/main_elevated_btn.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/core/components/screens/screen_container.dart';
import 'package:redting/core/components/snack/snack.dart';
import 'package:redting/core/components/text/app_name_std_style.dart';
import 'package:redting/core/components/text_input/unstyled_input_txt.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';
import 'package:redting/features/profile/presentation/components/profile_photo_editor.dart';
import 'package:redting/features/profile/presentation/components/verification_video_editor.dart';
import 'package:redting/features/profile/presentation/state/user_profile_bloc.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/routes.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({
    Key? key,
  }) : super(key: key);

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

  UserProfileBloc? _eventDispatcher;
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
  bool _onGoingOpOnVideo = false;
  UserVerificationVideo? _profileVerificationVideo;
  File? _createdLocalVideoFile;

  //saving user profile
  bool _isCreatingUserProfile = false;

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
                                _profileMediaSection(
                                    screenWidth, screenHeight, blocContext),
                                _profileNonMediaSection(),
                                _getSaveButton(blocContext)
                              ],
                            ),
                          ),
                        ),
                      )));
            })));
  }

  /// WIDGETS
  Widget _profileMediaSection(
      double screenWidth, double screenHeight, BuildContext blocContext) {
    return Container(
      decoration: _getTopHalfDecor(screenHeight, screenWidth),
      child: Padding(
        padding: const EdgeInsets.only(top: paddingMd, bottom: paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfilePhotoEditor(
              isLoading: _isUploadingPhoto,
              profilePhoto: _profilePhoto,
              localPhoto: _selectedLocalPhotoFile,
              onError: (String err) {
                _showSnack(err);
              },
              onChange: (File? file, String? filename) {
                _onNewProfileImage(file, filename, blocContext);
              },
            ),
            const SizedBox(
              height: paddingSm,
            ),
            UnStyledTxtInput(
              controller: _nameController,
              keyboardType: TextInputType.name,
              hint: nameHint,
              constraints: const BoxConstraints(maxWidth: 200),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: paddingStd,
            ),
            VerificationVideoEditor(
              isVerified: _profileVerificationVideo != null,
              onCameraError: (String err) {
                _showSnack(err);
              },
              loadingVerificationCode: _loadingVerificationCode,
              isProcessingVideo: _onGoingOpOnVideo,
              verificationCode: _verificationCode,
              localVideoFile: _createdLocalVideoFile,
              onChanged: (File? createdLocalVideoFile) {
                _onNewVerificationVideoRecorded(
                    createdLocalVideoFile, blocContext);
              },
              discardLocalVideo: () {
                _onDeleteVerificationVideo(blocContext);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileNonMediaSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
            style: appTextTheme.subtitle2?.copyWith(color: Colors.black45),
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
    );
  }

  Widget _getSaveButton(BuildContext buildContext) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: paddingMd),
      constraints: const BoxConstraints(maxWidth: 400),
      child: MainElevatedBtn(
        onPressed: () {
          _createProfile(buildContext);
        },
        lbl: createProfileBtn,
        showLoading: _isCreatingUserProfile,
      ),
    );
  }

  /// ON CREATE PROFILE
  ///

  /// STATE CHANGE
  void _onInitState(BuildContext blocContext) {
    //get the verification code asap
    _eventDispatcher ??= BlocProvider.of<UserProfileBloc>(blocContext);
    _eventDispatcher?.add(GetVerificationVideoCodeEvent());
  }

  void _listenToProfilePhotoState(UserProfileState state) {
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
  }

  void _listenToVerificationVideoCodeState(UserProfileState state) {
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
  }

  void _listenToVerificationVideoState(UserProfileState state) {
    //creating / updating
    if (state is UpdatingVerificationVideoState) {
      setState(() {
        _onGoingOpOnVideo = true;
      });
    }

    if (state is UpdatedVerificationVideoState) {
      setState(() {
        _onGoingOpOnVideo = false;
        _profileVerificationVideo = state.userVerificationVideo;
        _showSnack(successUploadingVerificationVideo, isError: false);
      });
    }

    if (state is UpdatingVerificationVideoFailedState) {
      setState(() {
        _onGoingOpOnVideo = false;
        _profileVerificationVideo = null;
        _createdLocalVideoFile = null;
        _showSnack(state.errMsg);
      });
    }

    //deleting
    if (state is DeletedVerificationVideoState) {
      setState(() {
        _profileVerificationVideo = null;
        _onGoingOpOnVideo = false;
        _createdLocalVideoFile = null;
      });
    }

    if (state is DeletingVerificationVideoFailedState) {
      setState(() {
        _onGoingOpOnVideo = false;
        _showSnack(state.errMsg);
      });
    }

    if (state is DeletingVerificationVideoState) {
      setState(() {
        _onGoingOpOnVideo = true;
      });
    }
  }

  void _listenToProfileState(UserProfileState state) {
    if (state is CreatingUserProfileState) {
      setState(() {
        _isCreatingUserProfile = true;
      });
    }

    if (state is CreatedUserProfileState) {
      setState(() {
        _isCreatingUserProfile = false;
      });
      _showSnack(createProfileSuccess, isError: false);
      Navigator.pushReplacementNamed(
        context,
        splashRoute,
      );
    }

    if (state is ErrorCreatingUserProfileState) {
      setState(() {
        _isCreatingUserProfile = false;
      });
      _showSnack(state.errMsg ?? createProfileFail);
    }
  }

  void _listenToStateChange(BuildContext context, UserProfileState state) {
    _listenToProfilePhotoState(state);
    _listenToVerificationVideoCodeState(state);
    _listenToVerificationVideoState(state);
    _listenToProfileState(state);
  }

  /// EVENTS
  /// PROFILE PHOTO EVENTS
  bool _onGoingProcessBlockPhotoUpload() =>
      (_isCreatingUserProfile || _isUploadingPhoto);
  void _onNewProfileImage(
      File? file, String? filename, BuildContext blocContext) {
    if (_onGoingProcessBlockPhotoUpload()) return;
    if (file == null || filename == null) return;
    setState(() {
      _selectedLocalPhotoFile = file;
    });
    _eventDispatcher ??= BlocProvider.of<UserProfileBloc>(blocContext);
    _eventDispatcher?.add(ChangeProfilePhotoEvent(file, filename));
  }

  /// PROFILE VIDEO EVENTS
  bool _onGoingProcessBlockVideoUpload() =>
      (_isCreatingUserProfile || _onGoingOpOnVideo);
  void _onNewVerificationVideoRecorded(File? file, BuildContext blocContext) {
    if (_onGoingProcessBlockVideoUpload()) return;
    if (file == null || _verificationCode == null) return;
    setState(() {
      _createdLocalVideoFile = file;
    });
    _eventDispatcher ??= BlocProvider.of<UserProfileBloc>(blocContext);
    _eventDispatcher
        ?.add(ChangeVerificationVideoEvent(file, _verificationCode!));
  }

  void _onDeleteVerificationVideo(BuildContext blocContext) {
    if (_onGoingProcessBlockVideoUpload()) return;
    _eventDispatcher ??= BlocProvider.of<UserProfileBloc>(blocContext);
    _eventDispatcher?.add(DeleteVerificationVideoEvent());
  }

  ///PROFILE CREATION
  bool _onGoingProcessBlockProfileCreation() =>
      (_isCreatingUserProfile || _isUploadingPhoto || _onGoingOpOnVideo);
  void _createProfile(BuildContext blocContext) {
    if (_onGoingProcessBlockProfileCreation()) return;
    _eventDispatcher ??= BlocProvider.of<UserProfileBloc>(blocContext);

    _eventDispatcher?.add(CreateUserProfileEvent(
        name: _nameController.text,
        userId: loggedInUser.userId,
        profilePhotoUrl: _profilePhoto ?? '',
        gender: _gender,
        genderOther:
            _gender == UserGender.stated ? _otherGenderController.text : null,
        bio: _bioController.text,
        title: _titleController.text,
        birthDay: _selectedBDay,
        registerCountry: '', //todo ?
        verificationVideo: _profileVerificationVideo));
  }

  /// GENDER
  Widget _getGenderWidgets() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _getGender(value: UserGender.female, lbl: femaleGender),
        const SizedBox(
          width: paddingStd,
        ),
        _getGender(value: UserGender.male, lbl: maleGender),
        const SizedBox(
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

  DateTime? _selectedBDay;
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

    _selectedBDay = await showDatePicker(
        context: context,
        initialDate: twentyFourYearsAgo,
        firstDate: hundredTwentyYearsBefore,
        lastDate: eighteenYearsAgo);

    if (mounted) {
      setState(() {
        _isDialogOpen = false;
        if (_selectedBDay != null) {
          _bDayController.text =
              "${_selectedBDay?.year} / ${_selectedBDay?.month} / ${_selectedBDay?.day} ";
        }
      });
    }
  }

  /// TOP DECOR
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

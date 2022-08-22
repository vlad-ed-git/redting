import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/buttons/main_elevated_btn.dart';
import 'package:redting/core/components/selectors/country_selector.dart';
import 'package:redting/core/components/snack/snack.dart';
import 'package:redting/core/components/text_input/unstyled_input_txt.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/presentation/components/profile_photo_editor.dart';
import 'package:redting/features/profile/presentation/components/screen_containers/edit_profile_container.dart';
import 'package:redting/features/profile/presentation/state/user_profile_bloc.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/routes.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;
  const EditProfileScreen({Key? key, required this.profile}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late UserProfile userProfile;
  late TextEditingController _nameController,
      _titleController,
      _bioController,
      _otherGenderController,
      _bDayController;
  late UserGender _gender;
  String? _otherGender;
  String _selectedCountry = '';

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

  //saving user profile
  bool _isUpdatingUserProfile = false;

  /// INIT
  @override
  void initState() {
    _initControllers();
    _initializeProfile();
    super.initState();
  }

  _initControllers() {
    _nameController = TextEditingController();
    _titleController = TextEditingController();
    _bioController = TextEditingController();
    _otherGenderController = TextEditingController();
    _bDayController = TextEditingController();
  }

  _initializeProfile() {
    UserProfile profile = widget.profile;
    userProfile = profile;
    _profilePhoto = profile.profilePhotoUrl;
    _nameController.text = profile.name;
    _titleController.text = profile.title;
    _bioController.text = profile.bio;
    _otherGenderController.text = profile.genderOther ?? '';
    _bDayController.text =
        "${profile.birthDay.year} / ${profile.birthDay.month} / ${profile.birthDay.day}";
    _gender = profile.getGender();
    _otherGender = profile.genderOther;
    _selectedCountry = profile.registerCountry;
  }

  /// BUILD
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: ProfilePhotoEditor(
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
                        style: appTextTheme.subtitle1
                            ?.copyWith(color: Colors.black),
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
                      CountrySelector(
                          selectedCountry: _selectedCountry,
                          onCountrySelected: (String country) {
                            setState(() {
                              _selectedCountry = country;
                            });
                          }),
                      const SizedBox(
                        height: paddingMd,
                      ),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 240),
                          child: MainElevatedBtn(
                            primaryBg: true,
                            showLoading: _isUpdatingUserProfile,
                            onClick: () {
                              _onSaveProfile(blocContext);
                            },
                            lbl: updateProfileBtn,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: paddingMd,
                      ),
                    ],
                  ));
            })));
  }

  void _onInitState(BuildContext blocContext) {
    //get the verification code asap
    _eventDispatcher ??= BlocProvider.of<UserProfileBloc>(blocContext);
  }

  void _listenToStateChange(BuildContext context, UserProfileState state) {
    _listenToProfilePhotoState(state);
    _listenToProfileState(state);
  }

  void _listenToProfileState(UserProfileState state) {
    if (state is UpdatingUserProfileState) {
      setState(() {
        _isUpdatingUserProfile = true;
      });
    }

    if (state is UpdatedUserProfileState) {
      setState(() {
        _isUpdatingUserProfile = false;
      });
      _showSnack(updateProfileSuccess, isError: false);
      Navigator.pushReplacementNamed(context, homeRoute,
          arguments: state.newProfile);
    }

    if (state is ErrorUpdatingUserProfileState) {
      setState(() {
        _isUpdatingUserProfile = false;
      });
      _showSnack(state.errMsg);
    }
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

  /// UI
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
            style: appTextTheme.subtitle2,
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
      hint: birthDayHint,
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

  /// EVENTS
  /// PROFILE PHOTO EVENTS
  bool _onGoingProcessBlockPhotoUpload() =>
      (_isUpdatingUserProfile || _isUploadingPhoto);
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

  void _onSaveProfile(BuildContext blocContext) {
    if (_onGoingProcessBlockPhotoUpload()) return;
    _eventDispatcher ??= BlocProvider.of<UserProfileBloc>(blocContext);
    _eventDispatcher?.add(UpdateUserProfileEvent(
        profile: widget.profile,
        name: _nameController.text,
        profilePhotoUrl: _profilePhoto ?? widget.profile.profilePhotoUrl,
        genderOther: _otherGender,
        gender: _gender,
        bio: _bioController.text,
        title: _titleController.text,
        birthDay: _selectedBDay ?? widget.profile.birthDay,
        registerCountry: _selectedCountry));
  }

  /// SNACK INFO
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
    _nameController.dispose();
    _titleController.dispose();
    _bioController.dispose();
    _otherGenderController.dispose();
    _bDayController.dispose();
    super.dispose();
  }
}

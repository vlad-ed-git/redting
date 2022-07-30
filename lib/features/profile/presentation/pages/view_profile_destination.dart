import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/core/components/snack/snack.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/presentation/components/view_only/profile_photo_uneditable.dart';
import 'package:redting/features/profile/presentation/state/user_profile_bloc.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({Key? key}) : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen>
    with AutomaticKeepAliveClientMixin<ViewProfileScreen> {
  @override
  bool get wantKeepAlive => true;

  bool _isInitialized = false;
  bool _isLoadingProfile = false;
  UserProfileBloc? _eventDispatcher;
  late UserProfile _userProfile;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
        lazy: false,
        create: (BuildContext blocProviderContext) =>
            GetIt.instance<UserProfileBloc>(),
        child: BlocListener<UserProfileBloc, UserProfileState>(
            listener: _listenToStateChange,
            child: BlocBuilder<UserProfileBloc, UserProfileState>(
                builder: (blocContext, state) {
              if (state is UserProfileInitialState && !_isInitialized) {
                _onInitState(blocContext);
              }
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!_isInitialized || _isLoadingProfile)
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgress(),
                      ),
                    if (_isInitialized && !_isLoadingProfile)
                      ..._buildUserProfileSections()
                  ],
                ),
              );
            })));
  }

  void _listenToStateChange(BuildContext context, UserProfileState state) {
    if (state is LoadingUserProfileState) {
      setState(() {
        _isLoadingProfile = true;
      });
    }

    if (state is LoadedUserProfileState) {
      setState(() {
        _userProfile = state.profile;
        _isInitialized = true;
        _isLoadingProfile = false;
      });
    }

    if (state is ErrorLoadingUserProfileState) {
      setState(() {
        _isInitialized = true;
        _isLoadingProfile = false;
        _showSnack(state.errMsg);
      });
    }
  }

  void _onInitState(BuildContext blocContext) {
    _eventDispatcher ??= BlocProvider.of<UserProfileBloc>(blocContext);
    _eventDispatcher?.add(LoadCachedProfileEvent());
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

  List<Widget> _buildUserProfileSections() {
    return <Widget>[
      Container(
          constraints: const BoxConstraints(
              maxHeight: avatarRadiusLg * 2.5, maxWidth: avatarRadiusLg * 2.5),
          child: Center(
              child: UneditableProfilePhoto(
                  profilePhoto: _userProfile.profilePhotoUrl))),
      Text(
        "${_userProfile.name} ${_userProfile.age}",
        style: appTextTheme.headline6
            ?.copyWith(color: appTheme.colorScheme.primary),
        textAlign: TextAlign.center,
      ),
      Text(
        _userProfile.title,
        style: appTextTheme.subtitle1,
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: paddingStd,
      ),
      Text(
        _userProfile.bio,
        style: appTextTheme.bodyText1,
        textAlign: TextAlign.justify,
      ),
      const SizedBox(
        height: paddingStd,
      ),
      _genderPill()
    ];
  }

  _genderPill() {
    UserGender userGender = _userProfile.getGender();
    String userGenderStr = "";
    switch (userGender) {
      case UserGender.male:
        userGenderStr = maleGender;
        break;
      case UserGender.female:
        if (_userProfile.genderOther != null) {
          userGenderStr = femaleGender;
        }
        break;
      case UserGender.stated:
        if (_userProfile.genderOther != null) {
          userGenderStr = _userProfile.genderOther!;
        }
        break;
    }
    if (userGenderStr.isEmpty) return const SizedBox.shrink();

    return Container(
      constraints: const BoxConstraints(maxWidth: 100),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: appTheme.colorScheme.primary.withOpacity(0.5))),
      child: Padding(
        padding: const EdgeInsets.all(paddingSm),
        child: Text(
          userGenderStr,
          style: appTextTheme.bodyText2?.copyWith(color: Colors.black),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _eventDispatcher?.close();
    super.dispose();
  }
}

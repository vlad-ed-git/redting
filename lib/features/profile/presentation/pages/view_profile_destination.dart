import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/buttons/main_elevated_btn.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/core/utils/consts.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/presentation/components/view_only/profile_photo_uneditable.dart';
import 'package:redting/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:redting/features/profile/presentation/state/user_profile_bloc.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/routes.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class ViewProfileScreen extends StatefulWidget {
  final UserProfile profile;
  const ViewProfileScreen({Key? key, required this.profile}) : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen>
    with AutomaticKeepAliveClientMixin<ViewProfileScreen> {
  @override
  bool get wantKeepAlive => true;

  UserProfileBloc? _eventDispatcher;

  final double thumbnailHeight = datingProfilePhotoSizeHeight / 4;
  final double thumbnailWidth = datingProfilePhotoSizeWidth / 2;

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
              if (state is UserProfileInitialState) {
                _onInitState(blocContext);
              }
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildUserProfileSections()),
              );
            })));
  }

  void _listenToStateChange(BuildContext context, UserProfileState state) {}

  void _onInitState(BuildContext blocContext) {
    _eventDispatcher ??= BlocProvider.of<UserProfileBloc>(blocContext);
  }

  List<Widget> _buildUserProfileSections() {
    return <Widget>[
      Center(
        child: Container(
          constraints: const BoxConstraints(
              maxHeight: avatarRadiusLg * 2.5, maxWidth: avatarRadiusLg * 2.5),
          child: UneditableProfilePhoto(
              profilePhoto: widget.profile.profilePhotoUrl),
        ),
      ),
      Text(
        "${widget.profile.name} ${widget.profile.age}",
        style: appTextTheme.headline6
            ?.copyWith(color: appTheme.colorScheme.primary),
        textAlign: TextAlign.center,
      ),
      Text(
        widget.profile.title,
        style: appTextTheme.subtitle1,
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: paddingStd,
      ),
      Text(
        widget.profile.bio,
        style: appTextTheme.bodyText1,
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: paddingStd,
      ),
      _genderPill(),
      const SizedBox(
        height: paddingStd,
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: widget.profile.datingPhotos
              .map((e) => _getDatingPicWidget(
                  e, const EdgeInsets.only(right: paddingStd)))
              .toList(growable: false),
        ),
      ),
      const SizedBox(
        height: paddingMd,
      ),
      Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: MainElevatedBtn(
              suffixIcon: Icons.edit,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      profile: widget.profile,
                    ),
                  ),
                );
              },
              showLoading: false,
              lbl: editProfile),
        ),
      ),
      const SizedBox(
        height: paddingMd,
      ),
      Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          child: MainElevatedBtn(
              suffixIcon: Icons.settings,
              onPressed: () {
                Navigator.pushNamed(context, editDatingPreferencesRoute,
                    arguments: widget.profile);
              },
              showLoading: false,
              lbl: editDatingPreferences),
        ),
      ),
      const SizedBox(
        height: paddingMd,
      ),
    ];
  }

  Widget _genderPill() {
    UserGender userGender = widget.profile.getGender();
    String userGenderStr = "";
    switch (userGender) {
      case UserGender.male:
        userGenderStr = maleGender;
        break;
      case UserGender.female:
        if (widget.profile.genderOther != null) {
          userGenderStr = femaleGender;
        }
        break;
      case UserGender.stated:
        if (widget.profile.genderOther != null) {
          userGenderStr = widget.profile.genderOther!;
        }
        break;
    }
    if (userGenderStr.isEmpty) return const SizedBox.shrink();

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 100),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: appTheme.colorScheme.primary.withOpacity(0.5))),
        child: Padding(
          padding: const EdgeInsets.all(paddingSm),
          child: Text(
            userGenderStr,
            style: appTextTheme.bodyText2?.copyWith(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _getDatingPicWidget(String datingPicUrl, EdgeInsets margins) {
    return Container(
      width: thumbnailWidth,
      height: thumbnailHeight,
      margin: margins,
      decoration: BoxDecoration(
          color: appTheme.colorScheme.inversePrimary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12)),
      child: AspectRatio(
        aspectRatio: thumbnailWidth / thumbnailHeight,
        child: CachedNetworkImage(
          imageUrl: datingPicUrl,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) {
            return const SizedBox.shrink();
          },
          placeholder: (_, __) {
            return const Center(
              child: CircularProgress(),
            );
          },
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

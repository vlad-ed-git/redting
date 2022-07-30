import 'package:flutter/material.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';
import 'package:redting/features/profile/presentation/components/view_only/profile_photo_uneditable.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';

chatAppBar({required MatchingMembers chattingWithUser}) {
  return AppBar(
    toolbarHeight: 100,
    centerTitle: true,
    elevation: paddingSm,
    shadowColor: Colors.black38,
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: paddingStd,
        ),
        Container(
            constraints: const BoxConstraints(
                maxHeight: avatarRadiusSmallest * 2.5,
                maxWidth: avatarRadiusSmallest * 2.5),
            child: Center(
                child: UneditableProfilePhoto(
                    isSmallest: true,
                    profilePhoto: chattingWithUser.userProfilePhoto))),
        const SizedBox(
          height: paddingSm,
        ),
        Text(
          chattingWithUser.userName,
          style: appTextTheme.bodyText2?.copyWith(color: Colors.black87),
        ),
        const SizedBox(
          height: paddingStd,
        ),
      ],
    ),
  );
}

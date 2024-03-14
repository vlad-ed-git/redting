import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redting/features/profile/presentation/components/view_only/profile_photo_circular_container.dart';
import 'package:redting/features/profile/presentation/components/view_only/profile_photo_loading_placeholder.dart';
import 'package:redting/features/profile/presentation/components/view_only/profile_photo_uneditable.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class ProfilePhotoEditor extends StatelessWidget {
  final String? profilePhoto;
  final Function(File? file, String? filename) onChange;
  final Function(String errMsg) onError;
  final bool isLoading;
  final File? localPhoto;
  const ProfilePhotoEditor({
    Key? key,
    this.profilePhoto,
    required this.onChange,
    required this.isLoading,
    required this.localPhoto,
    required this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: appTheme.colorScheme.secondary.withOpacity(0.2),
      borderRadius: BorderRadius.circular(avatarRadiusLg / 2),
      radius: avatarRadiusLg,
      onTap: _onPickImage,
      child: Center(child: _getDisplayImage()),
    );
  }

  void _onPickImage() async {
    try {
      if (isLoading) return;
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      File? newFile = pickedFile != null ? File(pickedFile.path) : null;
      String? filename = pickedFile?.name;
      onChange(newFile, filename);
    } catch (e) {
      onError(errPickingPhotoGallery);
    }
  }

  Widget _getDisplayImage() {
    if (profilePhoto != null) {
      return UneditableProfilePhoto(
        profilePhoto: profilePhoto!,
        placeholderImageProvider:
            (localPhoto != null ? FileImage(localPhoto!) : null),
      );
    }

    if (localPhoto != null) {
      //upload in progress
      return ProfilePhotoLoadingPlaceholder(
        imgProvider: localPhoto != null ? FileImage(localPhoto!) : null,
      );
    }

    return ProfilePhotoCircularContainer(
        child: Icon(
      Icons.person_add_alt,
      size: avatarRadiusLg / 1.5,
      color: appTheme.colorScheme.primary,
    ));
  }
}

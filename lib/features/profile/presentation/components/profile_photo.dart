import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class ProfilePhoto extends StatelessWidget {
  final String? profilePhoto;
  final Function(File? file) onChange;
  final Function(String errMsg) onError;
  final bool isLoading;
  final File? localPhoto;
  const ProfilePhoto({
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
      child: _getDisplayImage(),
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
      onChange(newFile);
    } catch (e) {
      onError(errPickingPhotoGallery);
    }
  }

  Widget _getCircularImageParent(
      {ImageProvider? imageProvider, Widget? child}) {
    return CircleAvatar(
      backgroundColor: appTheme.colorScheme.inversePrimary,
      radius: avatarRadiusLg,
      backgroundImage: imageProvider,
      child: child,
    );
  }

  Widget _getDisplayImage() {
    if (profilePhoto != null) {
      return CachedNetworkImage(
        imageUrl: profilePhoto!,
        imageBuilder: (context, imageProvider) =>
            _getCircularImageParent(imageProvider: imageProvider),
        placeholder: (context, url) => _loadingImage(),
      );
    }

    if (localPhoto != null) {
      //upload in progress
      return _loadingImage();
    }

    return _getCircularImageParent(
        child: Icon(
      Icons.person_add_alt,
      size: avatarRadiusLg / 1.5,
      color: appTheme.colorScheme.primary,
    ));
  }

  Widget _loadingImage() {
    return _getCircularImageParent(
        imageProvider: localPhoto != null ? FileImage(localPhoto!) : null,
        child: const Center(
          child: CircularProgress(),
        ));
  }
}

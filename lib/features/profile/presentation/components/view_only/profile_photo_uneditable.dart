import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redting/features/profile/presentation/components/view_only/profile_photo_circular_container.dart';
import 'package:redting/features/profile/presentation/components/view_only/profile_photo_loading_placeholder.dart';

class UneditableProfilePhoto extends StatelessWidget {
  final String profilePhoto;
  final ImageProvider? placeholderImageProvider;
  const UneditableProfilePhoto(
      {Key? key, required this.profilePhoto, this.placeholderImageProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: profilePhoto,
      imageBuilder: (context, imageProvider) =>
          ProfilePhotoCircularContainer(imageProvider: imageProvider),
      placeholder: (context, url) => ProfilePhotoLoadingPlaceholder(
        imgProvider: placeholderImageProvider,
      ),
    );
  }
}

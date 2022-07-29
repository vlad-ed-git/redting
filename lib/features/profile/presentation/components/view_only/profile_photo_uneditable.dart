import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redting/features/profile/presentation/components/view_only/profile_photo_circular_container.dart';
import 'package:redting/features/profile/presentation/components/view_only/profile_photo_loading_placeholder.dart';

class UneditableProfilePhoto extends StatelessWidget {
  final String profilePhoto;
  final ImageProvider? placeholderImageProvider;
  final bool isSmall, isSmallest;
  final double? useRadius;
  const UneditableProfilePhoto(
      {Key? key,
      required this.profilePhoto,
      this.placeholderImageProvider,
      this.isSmall = false,
      this.isSmallest = false,
      this.useRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: profilePhoto,
      imageBuilder: (context, imageProvider) => ProfilePhotoCircularContainer(
          imageProvider: imageProvider,
          isSmall: isSmall,
          useRadius: useRadius,
          isSmallest: isSmallest),
      placeholder: (context, url) => SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: ProfilePhotoLoadingPlaceholder(
            imgProvider: placeholderImageProvider,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/features/profile/presentation/components/view_only/profile_photo_circular_container.dart';

class ProfilePhotoLoadingPlaceholder extends StatelessWidget {
  final ImageProvider? imgProvider;
  const ProfilePhotoLoadingPlaceholder({Key? key, this.imgProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfilePhotoCircularContainer(
        imageProvider: imgProvider,
        child: const Center(
          child: CircularProgress(),
        ));
  }
}

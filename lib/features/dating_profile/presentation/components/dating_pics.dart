import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redting/core/utils/consts.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/theme.dart';

class DatingPicsWidget extends StatefulWidget {
  const DatingPicsWidget({Key? key}) : super(key: key);

  @override
  State<DatingPicsWidget> createState() => _DatingPicsWidgetState();
}

class _DatingPicsWidgetState extends State<DatingPicsWidget> {
  final double thumbnailHeight = datingProfilePhotoSizeHeight / 4;
  final double thumbnailWidth = datingProfilePhotoSizeWidth / 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: paddingMd, horizontal: paddingStd),
      child: Wrap(
        runAlignment: WrapAlignment.spaceEvenly,
        alignment: WrapAlignment.spaceEvenly,
        children: _getProfilePhotosAsThumbnails(),
      ),
    );
  }

  List<Widget> _getProfilePhotosAsThumbnails() {
    int i = 0;
    List<Widget> thumbnails = [];
    while (i < maxDatingProfilePhotos) {
      thumbnails.add(_getThumbnail());
      i++;
    }
    return thumbnails;
  }

  Widget _getThumbnail() {
    return SizedBox(
      width: thumbnailWidth + paddingMd,
      height: thumbnailHeight + paddingMd,
      child: Stack(children: [
        Container(
          width: thumbnailWidth,
          height: thumbnailHeight,
          decoration: BoxDecoration(
              color: appTheme.colorScheme.inversePrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12)),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            iconSize: 32,
            onPressed: () {},
            icon: Icon(
              Icons.add_circle_outlined,
              size: 32,
              color: appTheme.colorScheme.primary,
            ),
          ),
        )
      ]),
    );
  }
}

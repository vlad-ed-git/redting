import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/core/utils/consts.dart';
import 'package:redting/features/profile/domain/utils/dating_pic.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class DatingPicsWidget extends StatefulWidget {
  final List<DatingPic> datingPics;
  final bool disableClick;
  final Function(String errMsg) onError;
  final Function(int pos) onRemoveFile;
  final Function(File newFile, String filename, int photoNum) onChange;
  const DatingPicsWidget({
    Key? key,
    required this.datingPics,
    required this.disableClick,
    required this.onError,
    required this.onChange,
    required this.onRemoveFile,
  }) : super(key: key);

  @override
  State<DatingPicsWidget> createState() => _DatingPicsWidgetState();
}

class _DatingPicsWidgetState extends State<DatingPicsWidget> {
  final double thumbnailHeight = datingProfilePhotoSizeHeight / 4;
  final double thumbnailWidth = datingProfilePhotoSizeWidth / 2;
  final ImagePicker picker = ImagePicker();

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
      thumbnails.add(_getThumbnail(pos: i));
      i++;
    }
    return thumbnails;
  }

  Widget _getThumbnail({required int pos}) {
    File? localImgFile;
    String? existingPhoto;
    if (pos < maxDatingProfilePhotos) {
      if (widget.datingPics.length > pos) {
        localImgFile = widget.datingPics[pos].file;
        existingPhoto = widget.datingPics[pos].photoUrl;
      }
    }
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
          child: AspectRatio(
            aspectRatio: thumbnailWidth / thumbnailHeight,
            child: localImgFile != null
                ? Image.file(
                    localImgFile,
                    fit: BoxFit.cover,
                  )
                : existingPhoto != null
                    ? CachedNetworkImage(
                        imageUrl: existingPhoto,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) {
                          return Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 32,
                              color: appTheme.colorScheme.inversePrimary
                                  .withOpacity(0.2),
                            ),
                          );
                        },
                        progressIndicatorBuilder: (_, __, ___) {
                          return const Center(child: CircularProgress());
                        },
                      )
                    : const SizedBox.shrink(),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Material(
            elevation: paddingStd,
            color: appTheme.colorScheme.primaryContainer,
            shape: const CircleBorder(side: BorderSide.none),
            child: IconButton(
              iconSize: 24,
              onPressed: () {
                if (localImgFile == null && existingPhoto == null) {
                  _addPhoto(photoNum: pos);
                } else {
                  widget.onRemoveFile(pos);
                }
              },
              icon: Icon(
                (localImgFile != null || existingPhoto != null)
                    ? Icons.cancel
                    : Icons.add_circle_outlined,
                size: 32,
                color: appTheme.colorScheme.primary.withOpacity(0.7),
              ),
            ),
          ),
        )
      ]),
    );
  }

  void _addPhoto({required int photoNum}) async {
    try {
      if (widget.disableClick) return;
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      File? newFile = pickedFile != null ? File(pickedFile.path) : null;
      String? filename = pickedFile?.name;
      if (newFile != null && filename != null) {
        widget.onChange(newFile, filename, photoNum);
      }
    } catch (e) {
      widget.onError(errPickingPhotoGallery);
    }
  }
}

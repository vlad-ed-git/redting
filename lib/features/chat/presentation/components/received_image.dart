import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/res/dimens.dart';

class ReceivedImage extends StatelessWidget {
  final String photoUrl;
  const ReceivedImage({
    Key? key,
    required this.photoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
        margin: const EdgeInsets.only(top: paddingMd),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
                topRight: Radius.circular(12))),
        child: CachedNetworkImage(
          imageUrl: photoUrl,
          placeholder: (_, __) {
            return const Center(child: CircularProgress());
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

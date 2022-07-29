import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/res/dimens.dart';

class SentImage extends StatelessWidget {
  final String photoUrl;
  final Widget profileWidget;
  const SentImage({
    Key? key,
    required this.photoUrl,
    required this.profileWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
            margin: const EdgeInsets.only(top: paddingMd),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: CachedNetworkImage(
              imageUrl: photoUrl,
              placeholder: (_, __) {
                return const Center(child: CircularProgress());
              },
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: paddingSm,
          ),
          profileWidget
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/theme.dart';

class ReceivedImage extends StatelessWidget {
  final String photoUrl;
  final Widget profileWidget;
  const ReceivedImage({
    Key? key,
    required this.photoUrl,
    required this.profileWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: paddingSm,
          ),
          profileWidget,
          Container(
            constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
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
              errorWidget: (___, __, _) => SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Icon(Icons.error_outline,
                      color: appTheme.colorScheme.primary),
                ),
              ),
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

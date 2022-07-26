import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redting/core/components/misc/darkish_transparent_layer.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/features/home/presentation/components/swipeable_profile.dart';
import 'package:redting/features/home/presentation/components/swipeable_profile_components/container_card.dart';
import 'package:redting/features/home/presentation/components/swipeable_profile_components/overview_text.dart';
import 'package:redting/features/home/presentation/components/swipeable_profile_components/stamp.dart';

class ProfileOverView extends StatelessWidget {
  final CardSwipeType stampToShow;
  final String name;
  final String age;
  final String title;
  final double cardWidth;
  final double cardHeight;
  final String mainPhoto;
  const ProfileOverView(
      {Key? key,
      required this.stampToShow,
      required this.name,
      required this.age,
      required this.title,
      required this.cardWidth,
      required this.cardHeight,
      required this.mainPhoto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileContainerCard(
        cardWidth: cardWidth,
        cardHeight: cardHeight,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: CachedNetworkImage(
                  height: cardHeight,
                  imageUrl: mainPhoto,
                  fit: BoxFit.cover,
                  placeholder: (_, __) {
                    return const Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgress(),
                      ),
                    );
                  }),
            ),
            const TransparentLayer(),
            Visibility(
              visible: stampToShow == CardSwipeType.pass,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: CardStamp(forType: CardSwipeType.pass),
              ),
            ),
            Visibility(
              visible: stampToShow == CardSwipeType.like,
              child: const Align(
                alignment: Alignment.centerRight,
                child: CardStamp(forType: CardSwipeType.like),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: OverviewText(
                  name: name, age: age, title: title, cardWidth: cardWidth),
            )
          ],
        ));
  }
}

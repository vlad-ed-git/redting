import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redting/core/components/cards/glass_card.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/theme.dart';

class SwipeProfile extends StatefulWidget {
  final String photoUrl;
  final String name;
  final String age;
  final String title;
  final bool isFrontCard;
  final Function(CardSwipeType gesture) onSwiped;
  const SwipeProfile(
      {Key? key,
      required this.photoUrl,
      required this.name,
      required this.age,
      required this.title,
      required this.isFrontCard,
      required this.onSwiped})
      : super(key: key);

  @override
  State<SwipeProfile> createState() => _SwipeProfileState();
}

class _SwipeProfileState extends State<SwipeProfile> {
  bool _isDragging = false;
  Offset _dragPosition = Offset.zero;
  double _rotationAngle = 0;
  late Size _screenSize;

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return widget.isFrontCard ? _draggableProfileCard() : _profileCard();
  }

  void _onStartDrag(DragStartDetails details) {
    if (mounted) {
      setState(() {
        _isDragging = true;
      });
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (mounted) {
      setState(() {
        _dragPosition += details.delta;
        final x = _dragPosition.dx;
        _rotationAngle = 45 * x / _screenSize.width; //45 is angle of rotation
      });
    }
  }

  void _onEndDrag(DragEndDetails details) {
    if (mounted) {
      setState(() {
        _isDragging = false;
      });
      CardSwipeType type = _getCardSwipeType();
      switch (type) {
        case CardSwipeType.like:
          _likeAnimation();
          break;
        case CardSwipeType.pass:
          _passAnimation();
          break;
        case CardSwipeType.superLike:
          _superLikeAnimation();
          break;
        case CardSwipeType.unknown:
          //reset
          setState(() {
            _dragPosition = Offset.zero;
            _rotationAngle = 0;
          });
          break;
      }
    }
  }

  CardSwipeType _getCardSwipeType() {
    final x = _dragPosition.dx;
    final y = _dragPosition.dy;
    final isStraightUp = x.abs() < 20;

    if (x >= 100) {
      return CardSwipeType.like;
    }

    if (x <= -100) {
      return CardSwipeType.pass;
    }

    if (y <= -50 && isStraightUp) {
      return CardSwipeType.superLike;
    }

    return CardSwipeType.unknown;
  }

  /// UI
  Widget _profileCard() {
    double cardWidth = _screenSize.width - (paddingMd * 2);
    double cardHeight = _screenSize.height * 0.7;
    return GlassCard(
      wrapInChildScrollable: false,
      constraints: BoxConstraints(
        maxWidth: cardWidth,
        minHeight: cardHeight,
        maxHeight: cardHeight,
      ),
      contentPadding: EdgeInsets.zero,
      child: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: CachedNetworkImage(
                  height: cardHeight,
                  imageUrl: widget.photoUrl,
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
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildBottomText(cardWidth),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomText(double cardWidth) {
    return SizedBox(
      width: cardWidth,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(paddingStd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.name,
                  style: appTextTheme.headline4
                      ?.copyWith(color: appTheme.colorScheme.onPrimary),
                ),
                const SizedBox(
                  width: paddingStd,
                ),
                Expanded(
                    child: Text(widget.age,
                        style: appTextTheme.headline4
                            ?.copyWith(color: appTheme.colorScheme.onPrimary)))
              ],
            ),
            Text(
              widget.title.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: appTextTheme.headline5
                  ?.copyWith(color: appTheme.colorScheme.onPrimary),
            )
          ],
        ),
      ),
    );
  }

  Widget _draggableProfileCard() {
    return GestureDetector(
      onPanStart: (details) {
        _onStartDrag(details);
      },
      onPanEnd: (details) {
        _onEndDrag(details);
      },
      onPanUpdate: (details) {
        _onDragUpdate(details);
      },
      child: LayoutBuilder(builder: (context, constraints) {
        final center = constraints.smallest.center(Offset.zero);
        final rotateAngle = _rotationAngle * pi / 180;
        final rotatedMatrix = Matrix4.identity()
          ..translate(center.dx, center.dy)
          ..rotateZ(rotateAngle)
          ..translate(-center.dx, -center.dy);
        final animatedDuration = _isDragging ? 0 : 400;
        return AnimatedContainer(
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: animatedDuration),
          transform: rotatedMatrix
            ..translate(_dragPosition.dx, _dragPosition.dy),
          child: _profileCard(),
        );
      }),
    );
  }

  /// SWIPE ANIMATION
  void _likeAnimation() async {
    setState(() {
      _rotationAngle = 20;
      _dragPosition += Offset(_screenSize.width * 2, 0);
    });
    await Future.delayed(const Duration(milliseconds: 200));
    widget.onSwiped(CardSwipeType.like);
  }

  void _passAnimation() async {
    setState(() {
      _rotationAngle = -20;
      _dragPosition -= Offset(_screenSize.width * 2, 0);
    });
    await Future.delayed(const Duration(milliseconds: 200));
    widget.onSwiped(CardSwipeType.pass);
  }

  void _superLikeAnimation() async {
    setState(() {
      _rotationAngle = 0;
      _dragPosition -= Offset(
        0,
        _screenSize.height,
      );
    });
    await Future.delayed(const Duration(milliseconds: 200));
    widget.onSwiped(CardSwipeType.superLike);
  }
}

class TransparentLayer extends StatefulWidget {
  const TransparentLayer({Key? key}) : super(key: key);

  @override
  State<TransparentLayer> createState() => _TransparentLayerState();
}

class _TransparentLayerState extends State<TransparentLayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
      Colors.transparent,
      Colors.black,
    ], stops: [
      0.7,
      1
    ], begin: Alignment.topCenter, end: Alignment.bottomCenter)));
  }
}

enum CardSwipeType { like, pass, superLike, unknown }

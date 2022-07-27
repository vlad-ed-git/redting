import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:redting/features/dating_profile/domain/models/sexual_orientation.dart';
import 'package:redting/features/matching/presentation/components/swipeable_profile_components/detailed_view.dart';
import 'package:redting/features/matching/presentation/components/swipeable_profile_components/overview.dart';
import 'package:redting/features/profile/domain/models/user_verification_video.dart';
import 'package:redting/res/dimens.dart';

class SwipeProfile extends StatefulWidget {
  final List<String> photoUrls;
  final String name;
  final String age;
  final String title;
  final bool isFrontCard;
  final Function(CardSwipeType gesture) onSwiped;
  final String bio;
  final UserVerificationVideo verificationVideo;
  final List<SexualOrientation> sexualOrientation;
  const SwipeProfile({
    Key? key,
    required this.photoUrls,
    required this.name,
    required this.age,
    required this.title,
    required this.isFrontCard,
    required this.onSwiped,
    required this.bio,
    required this.verificationVideo,
    required this.sexualOrientation,
  }) : super(key: key);

  @override
  State<SwipeProfile> createState() => _SwipeProfileState();
}

class _SwipeProfileState extends State<SwipeProfile> {
  bool _isDragging = false;
  Offset _dragPosition = Offset.zero;
  double _rotationAngle = 0;
  late Size _screenSize;
  CardSwipeType _stampToShow = CardSwipeType.noAction;
  bool _switchToDetailedView = false;

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return widget.isFrontCard
        ? _draggableProfileCard()
        : _showProfileOverview();
  }

  double cardWidth() => _screenSize.width - (paddingMd * 2);
  double cardHeight() => _screenSize.height * 0.7;

  /// UI
  _showProfileOverview() {
    return ProfileOverView(
        stampToShow: _stampToShow,
        name: widget.name,
        age: widget.age,
        title: widget.title,
        cardWidth: cardWidth(),
        cardHeight: cardHeight(),
        mainPhoto: widget.photoUrls.first);
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
          child: _switchToDetailedView
              ? DetailedViewCard(
                  bio: widget.bio,
                  verificationVideo: widget.verificationVideo,
                  sexualOrientation: widget.sexualOrientation,
                  cardWidth: cardWidth(),
                  cardHeight: cardHeight(),
                  photoUrls: widget.photoUrls)
              : _showProfileOverview(),
        );
      }),
    );
  }

  /// DRAG LISTENERS

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
        _stampToShow = _getCardSwipeType();
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
        case CardSwipeType.superlike:
          //todo
          break;
        case CardSwipeType.noAction:
          //reset
          setState(() {
            _dragPosition = Offset.zero;
            _rotationAngle = 0;
            _switchToDetailedView = !_switchToDetailedView;
          });
          break;
      }
      setState(() {
        _stampToShow = CardSwipeType.noAction;
      });
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

    if (y <= -20 && isStraightUp) {
      return CardSwipeType.superlike;
    }

    return CardSwipeType.noAction;
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
}

enum CardSwipeType { like, pass, superlike, noAction }

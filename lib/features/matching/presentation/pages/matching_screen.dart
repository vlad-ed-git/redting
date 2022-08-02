import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/snack/snack.dart';
import 'package:redting/features/matching/presentation/components/idle_matching_card.dart';
import 'package:redting/features/matching/presentation/components/loading_card.dart';
import 'package:redting/features/matching/presentation/components/rate_app_card.dart';
import 'package:redting/features/matching/presentation/components/swipeable_profile.dart';
import 'package:redting/features/matching/presentation/state/matching_bloc.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class MatchingScreen extends StatefulWidget {
  final UserProfile profile;
  const MatchingScreen({Key? key, required this.profile}) : super(key: key);

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen>
    with AutomaticKeepAliveClientMixin<MatchingScreen> {
  @override
  bool get wantKeepAlive => true;

  MatchingBloc? _eventDispatcher;
  bool _isLoading = false;
  bool _loadedAllProfiles = false;

  /// WE LOAD PROFILES IN BATCHES
  /// EACH TIME WE ADD THEM TO THE CURRENT SWIPE BATCH LIST [_currentSwipeBatchProfiles] IN REVERSE ORDER
  /// WE ADD THEM IN REVERSE ORDER BECAUSE THEY ARE STACKED, SO THE LAST WILL BE SHOWN FIRST
  /// THEN WE KEEP TRACK OF PASSED i.e. disliked profiles [_passedProfiles]
  /// WHEN WE REACH THE END [_loadedAllProfiles], THE USER CAN VIEW THE DISLIKED PROFILES AGAIN
  List<UserProfile> _currentSwipeBatchProfiles = [];
  final List<UserProfile> _passedProfiles = [];
  bool _todaysFeedbackReceived = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider(
      lazy: false,
      create: (BuildContext blocProviderContext) =>
          GetIt.instance<MatchingBloc>(),
      child: BlocBuilder<MatchingBloc, MatchingState>(
          builder: (blocContext, state) {
        if (state is MatchingInitialState) {
          _onInitState(blocContext);
        }
        return BlocListener<MatchingBloc, MatchingState>(
          listener: _listenToStates,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isLoading) const LoadingCard(),
              if (_currentSwipeBatchProfiles.isNotEmpty) _getSwipeAbleCards(),
              if (_shouldRevisitPassedOnProfiles()) _showRefreshOption(),
              if (_hasViewedAllProfiles())
                _getRateCard(state is SendingFeedbackState),
              if (_nothingElseToDo()) const IdleMatchingCard()
            ],
          ),
        );
      }),
    );
  }

  void _listenToStates(BuildContext context, MatchingState state) {
    if (state is LoadingState) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
    }
    if (state is FetchingMatchesFailedState) {
      _showSnack(state.errMsg);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    if (state is FetchedProfilesToMatchState) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          if (state.matchingProfiles.isNotEmpty) {
            _currentSwipeBatchProfiles =
                state.matchingProfiles.reversed.toList();
          } else {
            _loadedAllProfiles = true;
          }
        });
      }
    }

    /// liking user
    if (state is LikingUserFailedState) {
      if (mounted) {
        setState(() {
          _passedProfiles.add(state.likedUserProfile);
        });
      }
    }

    /// sending feedback
    if (state is SendingFeedbackSuccessState) {
      setState(() {
        _todaysFeedbackReceived = true;
      });
      _showSnack(feedbackReceived, isError: false);
    }

    if (state is SendingFeedbackFailedState) {
      _showSnack(feedbackNotSentErr, isError: false);
    }
  }

  void _onInitState(BuildContext blocContext) {
    _eventDispatcher ??= BlocProvider.of<MatchingBloc>(blocContext);
    _loadNextProfilestoMatchWithBatch();
  }

  void _loadNextProfilestoMatchWithBatch() {
    _eventDispatcher?.add(LoadProfilesToMatchEvent(widget.profile));
  }

  /// CARDS
  _getSwipeAbleCards() {
    if (_currentSwipeBatchProfiles.isEmpty) return const SizedBox.shrink();
    return Stack(
      children: _currentSwipeBatchProfiles.map((e) {
        bool isFrontCard = _currentSwipeBatchProfiles.last.userId == e.userId;
        return Align(
          alignment: Alignment.topCenter,
          child: SwipeProfile(
            photoUrls: e.datingPhotos,
            name: e.name,
            age: e.age.toString(),
            title: e.title,
            bio: e.bio,
            verificationVideo: e.getVerificationVideo(),
            sexualOrientation:
                e.makeMyOrientationPublic ? e.getUserSexualOrientation() : [],
            isFrontCard: isFrontCard,
            onSwiped: _onSwipe,
          ),
        );
      }).toList(),
    );
  }

  _onSwipe(CardSwipeType gesture) {
    if (mounted) {
      if (_currentSwipeBatchProfiles.isEmpty) return; //safe check
      final swipedProfile = _currentSwipeBatchProfiles.removeLast();
      if (_currentSwipeBatchProfiles.isEmpty) {
        _loadNextProfilestoMatchWithBatch();
      }
      //on like
      if (gesture == CardSwipeType.like) {
        setState(() {
          _currentSwipeBatchProfiles = _currentSwipeBatchProfiles;
        });
        _eventDispatcher?.add(LikeUserEvent(
            likedByUser: widget.profile.userId,
            likedUserProfile: swipedProfile));
        return;
      }
      //on pass
      if (gesture == CardSwipeType.pass) {
        _passedProfiles.add(swipedProfile);
        setState(() {
          _currentSwipeBatchProfiles = _currentSwipeBatchProfiles;
        });
        return;
      }
    }
  }

  /// RE VISIT PROFILES AGAIN
  Widget _showRefreshOption() {
    return Center(
      child: IconButton(
        icon: Icon(
          Icons.refresh_rounded,
          color: appTheme.colorScheme.primary,
        ),
        iconSize: 40,
        onPressed: _onReVisitProfiles,
      ),
    );
  }

  void _onReVisitProfiles() {
    if (mounted) {
      _currentSwipeBatchProfiles.clear();
      _currentSwipeBatchProfiles.addAll(_passedProfiles);
      _passedProfiles.clear();
      setState(() {
        _currentSwipeBatchProfiles = _currentSwipeBatchProfiles;
      });
    }
  }

  void _onSubmitDailyFeedback(int rating, String feedback) {
    _eventDispatcher?.add(SendUserFeedBackEvent(
        rating: rating, feedback: feedback, userId: widget.profile.userId));
  }

  _hasViewedAllProfiles() {
    return _passedProfiles.isEmpty &&
        _currentSwipeBatchProfiles.isEmpty &&
        _loadedAllProfiles &&
        !_todaysFeedbackReceived;
  }

  _shouldRevisitPassedOnProfiles() {
    return _passedProfiles.isNotEmpty &&
        _currentSwipeBatchProfiles.isEmpty &&
        _loadedAllProfiles;
  }

  _nothingElseToDo() {
    return _passedProfiles.isEmpty &&
        _currentSwipeBatchProfiles.isEmpty &&
        _loadedAllProfiles &&
        _todaysFeedbackReceived;
  }

  @override
  void dispose() {
    _eventDispatcher?.close();
    super.dispose();
  }

  ///snack
  void _showSnack(String err, {bool isError = true}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(Snack(
        content: err,
        isError: isError,
      ).create(context));
    }
  }

  Widget _getRateCard(bool isSendingFeedback) {
    return RateAppCard(
      isSendingFeedback: isSendingFeedback,
      onSubmitFeedback: _onSubmitDailyFeedback,
    );
  }
}

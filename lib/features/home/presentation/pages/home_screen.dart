import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/core/components/screens/screen_container.dart';
import 'package:redting/core/components/snack/snack.dart';
import 'package:redting/core/components/text/app_name_std_style.dart';
import 'package:redting/features/home/domain/repositories/matching_user_profile_wrapper.dart';
import 'package:redting/features/home/presentation/components/loading_card.dart';
import 'package:redting/features/home/presentation/components/swipeable_profile.dart';
import 'package:redting/features/home/presentation/state/matching_bloc.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MatchingBloc? _eventDispatcher;
  MatchingUserProfileWrapper? _thisUserInfo;
  bool _isLoading = false;
  bool _loadedAllProfiles = false;

  /// WE LOAD PROFILES IN BATCHES
  /// EACH TIME WE ADD THEM TO THE CURRENT SWIPE BATCH LIST [_currentSwipeBatchProfiles] IN REVERSE ORDER
  /// WE ADD THEM IN REVERSE ORDER BECAUSE THEY ARE STACKED, SO THE LAST WILL BE SHOWN FIRST
  /// THEN WE KEEP TRACK OF PASSED i.e. disliked profiles [_passedProfiles]
  /// WHEN WE REACH THE END [_loadedAllProfiles], THE USER CAN VIEW THE DISLIKED PROFILES AGAIN
  List<MatchingUserProfileWrapper> _currentSwipeBatchProfiles = [];
  final List<MatchingUserProfileWrapper> _passedProfiles = [];

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
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
            child: ScreenContainer(
                child: Scaffold(
                    extendBodyBehindAppBar: false,
                    appBar: AppBar(
                      toolbarHeight: appBarHeight,
                      backgroundColor: Colors.transparent,
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [StdAppName()]),
                    ),
                    body: Container(
                      decoration:
                          BoxDecoration(gradient: threeColorOpaqueGradientTB),
                      constraints: BoxConstraints(
                          minWidth: screenWidth, minHeight: screenHeight),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: paddingMd, horizontal: paddingStd),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_isLoading) const LoadingCard(),
                            if (_currentSwipeBatchProfiles.isNotEmpty)
                              _getSwipeAbleCards(),
                            if (_passedProfiles.isNotEmpty &&
                                _currentSwipeBatchProfiles.isEmpty &&
                                _loadedAllProfiles)
                              _showRefreshOption()
                          ],
                        ),
                      ),
                    ))),
          );
        }));
  }

  void _listenToStates(BuildContext context, MatchingState state) {
    if (state is InitializedMatchingState) {
      _loadInitialMatchingProfiles(context, state);
    }

    if (state is LoadingState) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
    }

    if (state is InitializingMatchingFailedState) {
      _showSnack(state.errMsg);
      if (mounted) {
        setState(() {
          _isLoading = false;
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
  }

  void _onInitState(BuildContext blocContext) {
    _eventDispatcher ??= BlocProvider.of<MatchingBloc>(blocContext);
    _eventDispatcher?.add(InitializeEvent());
  }

  void _loadInitialMatchingProfiles(
    BuildContext blocContext,
    InitializedMatchingState state,
  ) {
    if (mounted) {
      setState(() {
        _thisUserInfo = state.wrapper;
        _isLoading = false;
      });
    }
    _eventDispatcher ??= BlocProvider.of<MatchingBloc>(blocContext);
    _loadNextProfilesBatch();
  }

  void _loadNextProfilesBatch() {
    if (_thisUserInfo == null) return;
    _eventDispatcher?.add(LoadProfilesEvent(_thisUserInfo!));
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

  _getSwipeAbleCards() {
    if (_currentSwipeBatchProfiles.isEmpty) return const SizedBox.shrink();
    return Stack(
      children: _currentSwipeBatchProfiles.map((e) {
        bool isFrontCard = _currentSwipeBatchProfiles.last.userProfile.userId ==
            e.userProfile.userId;
        return SwipeProfile(
          photoUrl: e.datingProfile.photos.first,
          name: e.userProfile.name,
          age: e.userProfile.age.toString(),
          title: e.userProfile.title,
          isFrontCard: isFrontCard,
          onSwiped: _onSwipe,
        );
      }).toList(),
    );
  }

  _onSwipe(CardSwipeType gesture) {
    if (mounted) {
      if (_currentSwipeBatchProfiles.isEmpty) return; //safe check
      final last = _currentSwipeBatchProfiles.removeLast();
      if (_currentSwipeBatchProfiles.isEmpty) {
        _loadNextProfilesBatch();
      }
      switch (gesture) {
        case CardSwipeType.like:
          setState(() {
            _currentSwipeBatchProfiles = _currentSwipeBatchProfiles;
          });
          break;
        case CardSwipeType.pass:
          _passedProfiles.add(last);
          setState(() {
            _currentSwipeBatchProfiles = _currentSwipeBatchProfiles;
          });
          break;
        case CardSwipeType.superLike:
          setState(() {
            _currentSwipeBatchProfiles = _currentSwipeBatchProfiles;
          });
          break;
        case CardSwipeType.unknown:
          break; //do nothing
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
}
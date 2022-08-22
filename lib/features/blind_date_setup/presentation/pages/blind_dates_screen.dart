import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/snack/snack.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/blind_date_setup/domain/model/blind_date.dart';
import 'package:redting/features/blind_date_setup/presentation/pages/state/fetch/load_blind_dates_bloc.dart';
import 'package:redting/features/chat/presentation/pages/chat_screen.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/theme.dart';

class BlindDatesScreen extends StatefulWidget {
  const BlindDatesScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BlindDatesScreen> createState() => _BlindDatesScreenState();
}

class _BlindDatesScreenState extends State<BlindDatesScreen> {
  LoadBlindDatesBloc? _eventDispatcher;
  bool _hasFetchedAllBlindDates = false;
  bool _isLoadingBlindDates = false;

  Stream<List<OperationRealTimeResult>>? _stream;
  late ScrollController _blindDatesScrollController;
  Map<String, BlindDate> _blindDates = {};

  //init with an old year
  DateTime _mostRecentDate = DateTime(2021);
  late AuthUser _authUser;

  @override
  void initState() {
    _blindDatesScrollController = ScrollController();
    _addScrollListener();
    super.initState();
  }

  @override
  Widget build(BuildContext cxt) {
    return BlocProvider(
        lazy: false,
        create: (BuildContext blocProviderContext) =>
            GetIt.instance<LoadBlindDatesBloc>(),
        child: BlocListener<LoadBlindDatesBloc, LoadBlindDatesState>(
            listener: _listenToStateChange,
            child: BlocBuilder<LoadBlindDatesBloc, LoadBlindDatesState>(
                builder: (blocContext, state) {
              if (state is LoadBlindDatesInitial) {
                _onInitState(blocContext);
              }
              return StreamBuilder<List<OperationRealTimeResult>>(
                  stream: _stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      _respondToDataChanges(snapshot.data!);
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: _blindDatesScrollController,
                      itemCount: _blindDates.values.length,
                      itemBuilder: (BuildContext context, int index) {
                        BlindDate date = _blindDates.values.toList()[index];
                        return _buildBlindDateWidget(date);
                      },
                    );
                  });
            })));
  }

  /// INIT
  void _onInitState(BuildContext blocContext) {
    _eventDispatcher ??= BlocProvider.of<LoadBlindDatesBloc>(blocContext);
    _eventDispatcher?.add(GetAuthUserEvent());
  }

  /// LISTEN TO STATE
  void _listenToStateChange(BuildContext context, LoadBlindDatesState state) {
    /// AUTH USER
    if (state is GettingAuthUserState) {
      setState(() {
        _isLoadingBlindDates = true;
      });
    }
    if (state is GettingAuthUserFailedState) {
      setState(() {
        _isLoadingBlindDates = false;
      });
      _showSnack(state.errMsg);
    }
    if (state is GettingAuthUserSuccessfulState) {
      _authUser = state.user;
      _eventDispatcher?.add(ListenToBlindDatesEvent(
        userId: _authUser.userId,
      ));
    }

    if (state is ListeningToBlindDatesState) {
      if (!mounted) return;
      setState(() {
        _stream = state.stream;
        _isLoadingBlindDates = false;
      });
    }

    /// loading old blindDates
    if (state is LoadingState) {
      if (!mounted) return;
      setState(() {
        _isLoadingBlindDates = true;
      });
    }

    if (state is LoadedOlderBlindDatesState) {
      for (BlindDate blindDate in state.dates) {
        _blindDates[blindDate.id] = blindDate;
      }
      if (!mounted) return;
      setState(() {
        _isLoadingBlindDates = false;
        _hasFetchedAllBlindDates = state.dates.isEmpty;
        _blindDates = _blindDates;
      });
    }
  }

  /// INCOMING MESSAGES  UPDATES
  void _respondToDataChanges(List<OperationRealTimeResult> resultsList) {
    for (var realTimeResult in resultsList) {
      BlindDate date = realTimeResult.data as BlindDate;
      switch (realTimeResult.realTimeEventType) {
        case RealTimeEventType.added:
          if (date.setupOn.isAfter(_mostRecentDate)) {
            //new blindDate - must add to back (since we are reversing the listview)
            Map<String, BlindDate> newBlindDates = {};
            newBlindDates[date.id] = date;
            newBlindDates.addAll(_blindDates);
            _blindDates = newBlindDates;

            //update most recent
            _mostRecentDate = date.setupOn;

            //scroll to bottom
            _scrollToBottomOfBlindDates();
          } else {
            _blindDates[date.id] = date;
          }
          break;

        case RealTimeEventType.modified:
          if (_blindDates.containsKey(date.id)) {
            _blindDates[date.id] = date;
          }
          break;

        case RealTimeEventType.deleted:
          if (_blindDates.containsKey(date.id)) {
            _blindDates.remove(date.id);
          }
          break;
      }
    }
  }

  void _scrollToBottomOfBlindDates() {
    _blindDatesScrollController.animateTo(
        _blindDatesScrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }

  void _addScrollListener() {
    _blindDatesScrollController.addListener(() {
      if (_blindDatesScrollController.offset <
              _blindDatesScrollController.position.maxScrollExtent &&
          !_blindDatesScrollController.position.outOfRange) {
        if (!_hasFetchedAllBlindDates && !_isLoadingBlindDates) {
          _eventDispatcher
              ?.add(LoadMoreBlindDatesEvent(userId: _authUser.userId));
        }
      }
    });
  }

  /// DISPOSE
  @override
  void dispose() {
    _blindDatesScrollController.dispose();
    super.dispose();
  }

  void _showSnack(String err, {bool isError = true}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(Snack(
        content: err,
        isError: isError,
      ).create(context));
    }
  }

  Widget _buildBlindDateWidget(BlindDate date) {
    try {
      MatchingMembers thisUser =
          date.toMatchingMembersType(thisUserId: _authUser.userId);
      MatchingMembers otherUser = date.toMatchingMembersType(
          thisUserId: date.members.firstWhere((id) => id != _authUser.userId));
      return Container(
        key: ValueKey(date.id),
        margin: const EdgeInsets.only(bottom: paddingStd),
        child: InkWell(
          splashColor: appTheme.colorScheme.primary,
          radius: 8,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                      thisUser: thisUser,
                      thatUser: otherUser,
                      iceBreaker: date.iceBreaker)),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Icon(
                Icons.person,
                size: 32,
                color: appTheme.colorScheme.secondary,
              )),
              const SizedBox(
                width: paddingStd,
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 32),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      otherUser.userName,
                      style: appTextTheme.subtitle1
                          ?.copyWith(color: Colors.black87),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } catch (e) {
      return const SizedBox.shrink(); //should never happen
    }
  }
}

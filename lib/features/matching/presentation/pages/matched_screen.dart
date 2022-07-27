import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';
import 'package:redting/features/matching/presentation/state/matches_listener/matches_listener_bloc.dart';

class MatchedScreen extends StatefulWidget {
  const MatchedScreen({Key? key}) : super(key: key);

  @override
  State<MatchedScreen> createState() => _MatchedScreenState();
}

class _MatchedScreenState extends State<MatchedScreen>
    with AutomaticKeepAliveClientMixin<MatchedScreen> {
  Stream<List<OperationRealTimeResult>>? _stream;
  MatchesListenerBloc? _eventDispatcher;

  @override
  bool get wantKeepAlive => true;
  bool _isInitialized = false;

  final messagesScrollController = ScrollController();
  Map<String, MatchingProfiles> _matchingProfiles = {};

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
        lazy: false,
        create: (BuildContext blocProviderContext) =>
            GetIt.instance<MatchesListenerBloc>(),
        child: BlocBuilder<MatchesListenerBloc, MatchesListenerState>(
            builder: (blocContext, state) {
          if (state is MatchesListenerInitialState && !_isInitialized) {
            _onInitState(blocContext);
          }
          return BlocListener<MatchesListenerBloc, MatchesListenerState>(
              listener: _listenToStates,
              child: StreamBuilder<List<OperationRealTimeResult>>(
                  stream: _stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      _respondToDataChanges(snapshot.data!);
                    }

                    if (snapshot.hasError) {
                      print("==== listening err ${snapshot.error} ===");
                    }

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _matchingProfiles.values
                            .map((value) =>
                                Text(value.getMembers().first.userName))
                            .toList());
                  }));
        }));
  }

  void _listenToStates(BuildContext context, MatchesListenerState state) {
    if (state is ListeningToMatchesState) {
      setState(() {
        _isInitialized = true;
        _stream = state.stream;
      });
    }
  }

  void _onInitState(BuildContext blocContext) {
    _eventDispatcher ??= BlocProvider.of<MatchesListenerBloc>(blocContext);
    _eventDispatcher?.add(ListenToMatchesEvent());
  }

  @override
  void dispose() {
    _eventDispatcher?.close();
    super.dispose();
  }

  void _respondToDataChanges(List<OperationRealTimeResult> data) {
    print(data);
    for (var realTimeResult in data) {
      MatchingProfiles matchingProfile =
          realTimeResult.data as MatchingProfiles;
      switch (realTimeResult.realTimeEventType) {
        case RealTimeEventType.added:
          _matchingProfiles[matchingProfile.userAUserBIdsConcatNSorted] =
              matchingProfile;
          break;

        case RealTimeEventType.modified:
          if (_matchingProfiles
              .containsKey(matchingProfile.userAUserBIdsConcatNSorted)) {
            _matchingProfiles[matchingProfile.userAUserBIdsConcatNSorted] =
                matchingProfile;
          }
          break;

        case RealTimeEventType.deleted:
          if (_matchingProfiles
              .containsKey(matchingProfile.userAUserBIdsConcatNSorted)) {
            _matchingProfiles
                .remove(matchingProfile.userAUserBIdsConcatNSorted);
          }
          break;
      }
    }
  }
}

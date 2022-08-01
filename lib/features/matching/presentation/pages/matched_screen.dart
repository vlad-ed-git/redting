import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/snack/snack.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/core/utils/txt_helpers.dart';
import 'package:redting/features/chat/presentation/pages/chat_screen.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';
import 'package:redting/features/matching/presentation/state/matches_listener/matches_listener_bloc.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/presentation/components/view_only/profile_photo_uneditable.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/theme.dart';

//TODO load more on scroll
class MatchedScreen extends StatefulWidget {
  const MatchedScreen({Key? key}) : super(key: key);

  @override
  State<MatchedScreen> createState() => _MatchedScreenState();
}

class _MatchedScreenState extends State<MatchedScreen>
    with AutomaticKeepAliveClientMixin<MatchedScreen> {
  Stream<List<OperationRealTimeResult>>? _stream;
  MatchesListenerBloc? _eventDispatcher;
  late UserProfile _thisUsersProfile;

  @override
  bool get wantKeepAlive => true;
  bool _isInitialized = false;

  final matchesScrollController = ScrollController();
  final Map<String, MatchingProfiles> _matchedProfiles = {};

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

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ListBody(
                          children: _matchedProfiles.values
                              .map((profile) => _matchToMessageWidget(profile))
                              .toList()),
                    );
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

    if (state is LoadedThisUserProfileState) {
      _thisUsersProfile = state.thisUserProfile;
      _eventDispatcher?.add(ListenToMatchesEvent());
    }

    if (state is LoadingThisUserProfileFailedState) {
      _showSnack(state.errMsg);
    }
  }

  void _onInitState(BuildContext blocContext) {
    _eventDispatcher ??= BlocProvider.of<MatchesListenerBloc>(blocContext);
    _eventDispatcher?.add(LoadThisUserProfileEvent());
  }

  @override
  void dispose() {
    _eventDispatcher?.close();
    super.dispose();
  }

  void _respondToDataChanges(List<OperationRealTimeResult> data) {
    for (var realTimeResult in data) {
      MatchingProfiles matchingProfile =
          realTimeResult.data as MatchingProfiles;
      switch (realTimeResult.realTimeEventType) {
        case RealTimeEventType.added:
          _matchedProfiles[matchingProfile.userAUserBIdsConcatNSorted] =
              matchingProfile;
          break;

        case RealTimeEventType.modified:
          if (_matchedProfiles
              .containsKey(matchingProfile.userAUserBIdsConcatNSorted)) {
            _matchedProfiles[matchingProfile.userAUserBIdsConcatNSorted] =
                matchingProfile;
          }
          break;

        case RealTimeEventType.deleted:
          if (_matchedProfiles
              .containsKey(matchingProfile.userAUserBIdsConcatNSorted)) {
            _matchedProfiles.remove(matchingProfile.userAUserBIdsConcatNSorted);
          }
          break;
      }
    }
  }

  Widget _matchToMessageWidget(MatchingProfiles profiles) {
    List<MatchingMembers> thisAndTheOtherUser = profiles.getMembers();
    final otherUser = thisAndTheOtherUser
        .firstWhere((profile) => profile.userId != _thisUsersProfile.userId);
    final thisUser = thisAndTheOtherUser
        .firstWhere((profile) => profile.userId == _thisUsersProfile.userId);
    final iceBreaker = profiles.iceBreakers[0];
    return Container(
      key: ValueKey(otherUser.userId),
      margin: const EdgeInsets.only(bottom: paddingMd),
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
                    iceBreaker: iceBreaker)),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                constraints: const BoxConstraints(
                    maxHeight: avatarRadiusSmall * 2.5,
                    maxWidth: avatarRadiusSmall * 2.5),
                child: Center(
                    child: UneditableProfilePhoto(
                        isSmall: true,
                        profilePhoto: otherUser.userProfilePhoto))),
            const SizedBox(
              width: paddingStd,
            ),
            Expanded(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(minHeight: avatarRadiusSmall * 2.5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        clipText(txt: otherUser.userName, maxChars: 24),
                        style: appTextTheme.subtitle1
                            ?.copyWith(color: Colors.black87),
                      ),
                      const SizedBox(
                        width: paddingStd,
                      ),
                      Text(
                          clipWords(
                            txt: iceBreaker,
                          ),
                          style: appTextTheme.bodyText1
                              ?.copyWith(color: Colors.black87))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
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
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/core/components/screens/screen_container.dart';
import 'package:redting/core/components/snack/snack.dart';
import 'package:redting/core/utils/service_result.dart';
import 'package:redting/features/chat/domain/models/message.dart';
import 'package:redting/features/chat/presentation/components/build_msg_widget_fun.dart';
import 'package:redting/features/chat/presentation/components/chat_app_bar.dart';
import 'package:redting/features/chat/presentation/components/ice_breaker_msg.dart';
import 'package:redting/features/chat/presentation/components/send_message.dart';
import 'package:redting/features/chat/presentation/pages/state/chat_bloc.dart';
import 'package:redting/features/matching/domain/models/matching_profiles.dart';
import 'package:redting/res/dimens.dart';

class ChatScreen extends StatefulWidget {
  final MatchingMembers thisUser;
  final MatchingMembers thatUser;
  final String iceBreaker;
  const ChatScreen(
      {Key? key,
      required this.thisUser,
      required this.thatUser,
      required this.iceBreaker})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isSendingMessage = false;
  ChatBloc? _eventDispatcher;
  bool _hasFetchedAllMessages = false;
  bool _isLoadingMessages = false;

  late TextEditingController _txtMsgController;
  Stream<List<OperationRealTimeResult>>? _stream;
  late ScrollController _messagesScrollController;
  Map<String, Message> _messages = {};
  DateTime _mostRecentMsgDate = DateTime(2021); //init with an old year

  @override
  void initState() {
    _txtMsgController = TextEditingController();
    _messagesScrollController = ScrollController();
    _addMsgScrollListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;
    return BlocProvider(
        lazy: false,
        create: (BuildContext blocProviderContext) =>
            GetIt.instance<ChatBloc>(),
        child: BlocListener<ChatBloc, ChatState>(
            listener: _listenToStateChange,
            child:
                BlocBuilder<ChatBloc, ChatState>(builder: (blocContext, state) {
              if (state is ChatInitialState) {
                _onInitState(blocContext);
              }
              return ScreenContainer(
                  child: Scaffold(
                appBar: chatAppBar(chattingWithUser: widget.thatUser),
                body: StreamBuilder<List<OperationRealTimeResult>>(
                    stream: _stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        _respondToDataChanges(snapshot.data!);
                      }
                      return Container(
                        color: Colors.grey.withOpacity(0.1),
                        constraints: BoxConstraints(
                            minHeight: screenHeight, minWidth: screenWidth),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: paddingMd,
                              left: paddingStd,
                              right: paddingStd),
                          child: Stack(
                            children: [
                              ListView(
                                  physics: const BouncingScrollPhysics(),
                                  controller: _messagesScrollController,
                                  reverse: true,
                                  children: [
                                    const SizedBox(
                                      height: 64,
                                    ),
                                    ..._messages.values
                                        .map((msg) => buildMessageWidget(msg,
                                            widget.thisUser, widget.thatUser))
                                        .toList(),
                                    if (_isLoadingMessages)
                                      Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: paddingStd),
                                          child: const Center(
                                              child: CircularProgress())),
                                    IceBreakerMsg(
                                        iceBreaker: widget.iceBreaker),
                                  ]),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: SendMessage(
                                  txtMsgController: _txtMsgController,
                                  isSendingMessage: _isSendingMessage,
                                  onSendTxtMessage: _onSendTxtMessage,
                                  onSendImageMessage: _onSendImgMessage,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ));
            })));
  }

  /// INIT
  void _onInitState(BuildContext blocContext) {
    _eventDispatcher ??= BlocProvider.of<ChatBloc>(blocContext);
    _eventDispatcher?.add(ListenToChatEvent(
        thisUser: widget.thisUser, thatUser: widget.thatUser));
    _isLoadingMessages = true;
  }

  /// EVENTS
  _onSendTxtMessage() {
    if (_isSendingMessage) return;
    String text = _txtMsgController.text;
    if (text.isEmpty) return;
    _eventDispatcher?.add(SendMessageEvent(
        message: text, thisUser: widget.thisUser, thatUser: widget.thatUser));
  }

  _onSendImgMessage({required String fileName, required File imageFile}) {
    if (_isSendingMessage) return;
    _eventDispatcher?.add(SendMessageEvent(
        thisUser: widget.thisUser,
        thatUser: widget.thatUser,
        imageFileName: fileName,
        imageFile: imageFile));
  }

  /// LISTEN TO STATE
  void _listenToStateChange(BuildContext context, ChatState state) {
    if (state is SendingMessageFailedState) {
      if (!mounted) return;
      setState(() {
        _isSendingMessage = false;
      });
      _showSnack(state.errMsg);
    }

    if (state is SendingMessageState) {
      if (!mounted) return;
      setState(() {
        _isSendingMessage = true;
      });
    }

    if (state is SendingMessageSuccessState) {
      if (!mounted) return;
      setState(() {
        _isSendingMessage = false;
      });
      _txtMsgController.clear();
    }

    if (state is ListeningToChatState) {
      if (!mounted) return;
      setState(() {
        _stream = state.stream;
        _isLoadingMessages = false;
      });
    }

    /// loading old messages
    if (state is ChatLoadingState) {
      if (!mounted) return;
      setState(() {
        _isLoadingMessages = true;
      });
    }

    if (state is LoadedOlderMessagesState) {
      for (Message message in state.messages) {
        _messages[message.uid] = message;
      }
      if (!mounted) return;
      setState(() {
        _isLoadingMessages = false;
        _hasFetchedAllMessages = state.messages.isEmpty;
        _messages = _messages;
      });
    }
  }

  /// INCOMING MESSAGES  UPDATES
  void _respondToDataChanges(List<OperationRealTimeResult> resultsList) {
    for (var realTimeResult in resultsList) {
      Message msg = realTimeResult.data as Message;
      switch (realTimeResult.realTimeEventType) {
        case RealTimeEventType.added:
          if (msg.sentAt.isAfter(_mostRecentMsgDate)) {
            //new message - must add to back (since we are reversing the listview)
            Map<String, Message> newMessages = {};
            newMessages[msg.uid] = msg;
            newMessages.addAll(_messages);
            _messages = newMessages;

            //update most recent
            _mostRecentMsgDate = msg.sentAt;

            //scroll to bottom
            _scrollToBottomOfMessages();
          } else {
            _messages[msg.uid] = msg;
          }
          break;

        case RealTimeEventType.modified:
          if (_messages.containsKey(msg.uid)) {
            _messages[msg.uid] = msg;
          }
          break;

        case RealTimeEventType.deleted:
          if (_messages.containsKey(msg.uid)) {
            _messages.remove(msg.uid);
          }
          break;
      }
    }
  }

  void _scrollToBottomOfMessages() {
    _messagesScrollController.animateTo(
        _messagesScrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }

  void _addMsgScrollListener() {
    _messagesScrollController.addListener(() {
      if (_messagesScrollController.offset >=
              _messagesScrollController.position.maxScrollExtent &&
          !_messagesScrollController.position.outOfRange) {
        if (!_hasFetchedAllMessages && !_isLoadingMessages) {
          _eventDispatcher?.add(LoadMoreMessagesEvent(
              thisUser: widget.thisUser, thatUser: widget.thatUser));
        }
      }
    });
  }

  /// DISPOSE
  @override
  void dispose() {
    _txtMsgController.dispose();
    _messagesScrollController.dispose();
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
}

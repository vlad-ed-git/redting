import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/buttons/main_elevated_btn.dart';
import 'package:redting/core/components/progress/circular_progress.dart';
import 'package:redting/core/components/screens/gradient_screen_container.dart';
import 'package:redting/core/components/screens/scaffold_wrapper.dart';
import 'package:redting/core/components/snack/snack.dart';
import 'package:redting/core/components/text_input/outlined_txtfield.dart';
import 'package:redting/features/auth/domain/models/auth_user.dart';
import 'package:redting/features/blind_date_setup/presentation/components/app_bar.dart';
import 'package:redting/features/blind_date_setup/presentation/pages/state/setup/blind_date_bloc.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class BlindDateSetupScreen extends StatefulWidget {
  final UserProfile userProfile;
  const BlindDateSetupScreen({Key? key, required this.userProfile})
      : super(key: key);

  @override
  State<BlindDateSetupScreen> createState() => _BlindDateSetupScreenState();
}

class _BlindDateSetupScreenState extends State<BlindDateSetupScreen> {
  late TextEditingController _phone1Controller, _phone2Controller;

  bool _isSending = false, _initializing = false;
  bool? _canSetupBlindDate;
  BlindDateBloc? _eventDispatcher;
  late AuthUser _authUser;
  final List<String> _iceBreakers = [defaultIceBreaker];
  String _chosenIceBreaker = defaultIceBreaker;

  @override
  void initState() {
    _phone1Controller = TextEditingController()..text = "8618616753659";
    _phone2Controller = TextEditingController()..text = "8610000000000";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: buildBlindDateScreenAppBar(),
        body: GradientScreenContainer(
          screen: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: BlocProvider(
                  lazy: false,
                  create: (BuildContext blocProviderContext) =>
                      GetIt.instance<BlindDateBloc>(),
                  child: BlocListener<BlindDateBloc, BlindDateState>(
                    listener: _listenToState,
                    child: BlocBuilder<BlindDateBloc, BlindDateState>(
                      builder: (blocContext, state) {
                        if (state is BlindDateInitial) {
                          _initialize(blocContext);
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_initializing)
                              const Center(child: CircularProgress()),
                            Text(
                              blindDateSetupTitle,
                              style: appTextTheme.headline6?.copyWith(
                                  color: appTheme.colorScheme.primary),
                            ),
                            RichText(
                              text: TextSpan(
                                text: blindDateSetupSubtitle,
                                style: appTextTheme.subtitle2?.copyWith(
                                    color: appTheme.colorScheme.secondary),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "\n • $blindDateInstructionsStep1",
                                      style: appTextTheme.button?.copyWith(
                                          color: Colors.black, height: 1.5)),
                                  TextSpan(
                                      text: '\n • $blindDateInstructionsStep2',
                                      style: appTextTheme.button?.copyWith(
                                          color: Colors.black, height: 1.5)),
                                  TextSpan(
                                      text: '\n • $blindDateInstructionsStep3',
                                      style: appTextTheme.button?.copyWith(
                                          color: Colors.black, height: 1.5)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: paddingStd,
                            ),
                            if (_canSetupBlindDate == false)
                              ..._buildCannotDateSetupViews(),
                            if (_canSetupBlindDate == true)
                              ..._buildBlindDateForm()
                          ],
                        );
                      },
                    ),
                  ))),
        ),
      ),
    );
  }

  /// state listener
  void _initialize(BuildContext blocContext) {
    _eventDispatcher ??= BlocProvider.of<BlindDateBloc>(blocContext);
    _eventDispatcher?.add(GetAuthUserEvent());
  }

  void _listenToState(BuildContext context, BlindDateState state) {
    /// AUTH USER
    if (state is GettingAuthUserState) {
      setState(() {
        _initializing = true;
      });
    }
    if (state is GettingAuthUserFailedState) {
      setState(() {
        _initializing = false;
      });
      _showSnack(state.errMsg);
    }
    if (state is GettingAuthUserSuccessfulState) {
      _authUser = state.user;
      _eventDispatcher?.add(CheckIfCanSetupBlindDateEvent(_authUser));
    }

    /// CAN SETUP
    if (state is CheckingIfCanSetupDateFailedState) {
      setState(() {
        _initializing = false;
      });
      _showSnack(state.errMsg);
    }
    if (state is CheckingIfCanSetupDateSuccessfulState) {
      setState(() {
        _canSetupBlindDate = state.canSetup;
      });
      _eventDispatcher?.add(GettingIceBreakersEvent());
    }

    /// ICE BREAKERS
    if (state is GettingIceBreakersSuccessState) {
      setState(() {
        _initializing = false;
      });
      if (state.iceBreakerMessages.messages.isNotEmpty) {
        _iceBreakers.clear();
        _iceBreakers.addAll(state.iceBreakerMessages.messages);
        _iceBreakers.shuffle();
        _chosenIceBreaker = _iceBreakers[0];
      }
    }

    if (state is GettingIceBreakersFailedState) {
      setState(() {
        _initializing = false;
      });
    }

    /// MATCH MAKING
    if (state is SettingUpBlindDateSuccessfulState) {
      setState(() {
        _isSending = false;
      });
      _showSnack(blindDateSetupSuccess, isError: false);
      _navigateAwayAfterSec();
    }
    if (state is SettingUpBlindDateState) {
      setState(() {
        _isSending = true;
      });
    }
    if (state is SettingUpBlindDateFailedState) {
      setState(() {
        _isSending = false;
      });
      _showSnack(state.errMsg);
    }
  }

  void _onSetupDateClicked() {
    _eventDispatcher?.add(SetupBlindDateEvent(_authUser, _phone1Controller.text,
        _phone2Controller.text, _chosenIceBreaker));
  }

  /// UI
  List<Widget> _buildBlindDateForm() {
    return <Widget>[
      Text(
        friend1PhoneNumberLbl,
        style: appTextTheme.subtitle2,
      ),
      const SizedBox(
        height: paddingSm,
      ),
      Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: OutlinedTxtField(
          prefixText: "+",
          txtInputAction: TextInputAction.next,
          controller: _phone1Controller,
          keyboardType: TextInputType.phone,
        ),
      ),
      const SizedBox(
        height: paddingStd,
      ),
      Text(
        friend2PhoneNumberLbl,
        style: appTextTheme.subtitle2,
      ),
      const SizedBox(
        height: paddingSm,
      ),
      Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: OutlinedTxtField(
          prefixText: "+",
          txtInputAction: TextInputAction.next,
          controller: _phone2Controller,
          keyboardType: TextInputType.phone,
        ),
      ),
      const SizedBox(
        height: paddingStd,
      ),
      Text(
        blindDateIceBreakerLbl,
        style: appTextTheme.subtitle2?.copyWith(color: Colors.black),
        softWrap: true,
      ),
      const SizedBox(
        height: paddingSm,
      ),
      Container(
        margin: const EdgeInsets.only(right: paddingStd),
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: _chosenIceBreaker,
            isExpanded: true,
            itemHeight: 52,
            menuMaxHeight: 300,
            borderRadius: BorderRadius.circular(12),
            underline: Container(
              height: 1,
              color: appTheme.colorScheme.secondary,
            ),
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            elevation: 16,
            dropdownColor: appTheme.colorScheme.inversePrimary,
            style: appTextTheme.bodyText2?.copyWith(color: Colors.black),
            onChanged: (String? newValue) {
              if (mounted && newValue != null) {
                setState(() {
                  _chosenIceBreaker = newValue;
                });
              }
            },
            items: _iceBreakers.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: appTextTheme.bodyText2?.copyWith(color: Colors.black),
                  softWrap: true,
                ),
              );
            }).toList(),
          ),
        ),
      ),
      const SizedBox(
        height: paddingStd,
      ),
      Text(
        blindDateHint,
        style: appTextTheme.caption,
      ),
      Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: paddingMd),
          constraints: const BoxConstraints(maxWidth: 240),
          child: MainElevatedBtn(
            primaryBg: true,
            showLoading: _isSending,
            onClick: () {
              _onSetupDateClicked();
            },
            lbl: blindDateSetupBtn,
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildCannotDateSetupViews() {
    return <Widget>[
      Text(
        cannotSetupBlindDateMaxReached,
        style:
            appTextTheme.subtitle2?.copyWith(color: appTheme.colorScheme.error),
      )
    ];
  }

  /// SNACK
  void _showSnack(String err, {bool isError = true}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(Snack(
        content: err,
        isError: isError,
      ).create(context));
    }
  }

  @override
  void dispose() {
    _phone1Controller.dispose();
    _phone2Controller.dispose();
    super.dispose();
  }

  void _navigateAwayAfterSec({Duration seconds = const Duration(seconds: 1)}) {
    Future.delayed(seconds, () {
      Navigator.pop(context);
    });
  }
}

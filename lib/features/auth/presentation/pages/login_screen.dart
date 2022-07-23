import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/core/components/buttons/main_elevated_btn.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/core/components/screens/screen_container.dart';
import 'package:redting/core/components/selectors/country_selector.dart';
import 'package:redting/core/components/text_input/outlined_txtfield.dart';
import 'package:redting/core/components/text_input/six_code_input.dart';
import 'package:redting/features/auth/presentation/state/auth_user_bloc.dart';
import 'package:redting/res/countries.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/routes.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _phoneController;
  String _selectedCountry = countryToPhoneCodeMap.keys.first;
  String _smsCode = "";
  LoginSteps _step = LoginSteps.getPhone;
  int? _resendToken;
  String _verificationId = "";
  String? _verificationErr;
  String? _signInErr;
  bool _isLoading = false;

  @override
  void initState() {
    _phoneController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
        lazy: false,
        create: (BuildContext blocProviderContext) =>
            GetIt.instance<AuthUserBloc>(),
        child: BlocListener<AuthUserBloc, AuthUserState>(
          listener: _listenToStateChange,
          child: BlocBuilder<AuthUserBloc, AuthUserState>(
              builder: (blocContext, state) {
            return ScreenContainer(
                child: WillPopScope(
              onWillPop: () async {
                return _onBackPressed(blocContext);
              },
              child: Scaffold(
                  extendBodyBehindAppBar: true,
                  body: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                          minWidth: screenWidth, minHeight: screenHeight),
                      decoration:
                          BoxDecoration(gradient: threeColorOpaqueGradientTB),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: paddingMd, horizontal: paddingLg),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                loginTitle,
                                style: appTextTheme.headline2,
                              ),
                              const SizedBox(
                                height: paddingStd,
                              ),
                              if (_step == LoginSteps.getPhone)
                                ..._getPhoneStepWidgets(),
                              if (_step == LoginSteps.verifyPhone)
                                ..._getVerificationStepWidgets(blocContext),
                              const SizedBox(
                                height: paddingSm,
                              ),
                              _getContinueBtn(blocContext)
                            ]),
                      ),
                    ),
                  )),
            ));
          }),
        ));
  }

  /// STEP 1 GET PHONE
  List<Widget> _getPhoneStepWidgets() {
    return [
      Text(
        phoneNumberLbl,
        style: appTextTheme.subtitle2,
      ),
      const SizedBox(
        height: paddingSm,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CountrySelector(
              selectedCountry: _selectedCountry,
              onCountrySelected: (String country) {
                setState(() {
                  _selectedCountry = country;
                });
              }),
          Expanded(
            child: OutlinedTxtField(
              txtInputAction: TextInputAction.done,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
          ),
        ],
      ),
      Visibility(
        visible: _verificationErr != null,
        child: Container(
          margin: const EdgeInsets.only(top: paddingSm),
          child: Text(
            _verificationErr ?? '',
            textAlign: TextAlign.justify,
            style: appTextTheme.caption
                ?.copyWith(color: appTheme.colorScheme.error),
          ),
        ),
      ),
      const SizedBox(
        height: paddingSm,
      ),
      Text(
        phoneVerificationHint,
        textAlign: TextAlign.justify,
        style: appTextTheme.caption?.copyWith(color: Colors.black54),
      ),
    ];
  }

  /// STEP 2 VERIFY PHONE
  List<Widget> _getVerificationStepWidgets(BuildContext blocContext) {
    return <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              "$enterCodeSentTo ${countryToPhoneCodeMap[_selectedCountry]} ${_phoneController.text}",
              style: appTextTheme.subtitle2,
            ),
          ),
          SizedBox(
            width: 100,
            child: InkWell(
              splashColor: appTheme.colorScheme.primary,
              radius: 14,
              onTap: () {
                _onSendOrResendCodeClicked(blocContext);
              },
              child: Text(
                resendTxt,
                style: appTextTheme.button?.copyWith(
                  color: appTheme.colorScheme.secondary,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          )
        ],
      ),
      const SizedBox(
        height: paddingSm,
      ),
      SixDigitCodeInput(
        onUpdateCode: (String code) {
          setState(() {
            _smsCode = code;
          });
        },
      ),
      Visibility(
        visible: _signInErr != null,
        child: Container(
          margin: const EdgeInsets.only(top: paddingSm),
          child: Text(
            _signInErr ?? '',
            style: appTextTheme.bodyText2
                ?.copyWith(color: appTheme.colorScheme.error),
          ),
        ),
      ),
      const SizedBox(
        height: paddingSm,
      ),
      SizedBox(
        height: 40,
        child: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            splashColor: appTheme.colorScheme.primary,
            radius: 14,
            onTap: () {
              _goToGetPhone(blocContext);
            },
            child: Text(
              changePhoneTxt,
              style: appTextTheme.button?.copyWith(
                color: appTheme.colorScheme.secondary,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ),
      ),
      ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 40),
        child: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            splashColor: appTheme.colorScheme.primary,
            radius: 14,
            child: Text(
              signInTerms,
              style: appTextTheme.caption?.copyWith(color: Colors.black54),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      )
    ];
  }

  ///SIGN IN BTN
  Widget _getContinueBtn(BuildContext blocContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 200, maxWidth: 200),
          child: MainElevatedBtn(
          onPressed: () {
          _onClickedContinue(blocContext);
          },
       lbl: loginBtn,
            showLoading: _isLoading,
          ),
        ),
      ],
    );
  }

  /// STATE
  void _listenToStateChange(BuildContext context, AuthUserState state) {
    if (state is GetPhoneState) {
      setState(() {
        _step = LoginSteps.getPhone;
      });
    }

    if (state is GetCodeState) {
      setState(() {
        _step = LoginSteps.verifyPhone;
      });
    }

    if (state is CodeSentToPhoneState) {
      setState(() {
        _verificationId = state.verificationId;
        _resendToken = state.resendToken;
        _step = LoginSteps.verifyPhone;
        _isLoading = false;
      });
    }

    if (state is VerificationFailedState) {
      setState(() {
        _verificationErr = state.errMsg;
        _isLoading = false;
      });
    }

    if (state is SigningUserInFailedState) {
      setState(() {
        _signInErr = state.errMsg;
        _isLoading = false;
      });
    }

    if (state is UserSignedInState) {
      setState(() {
        _isLoading = false;
        _step = LoginSteps.signedIn;
        //GO BACK TO SPLASH
        Navigator.pushReplacementNamed(
          context,
          splashRoute,
        );
      });
    }

    if (state is LoadingAuthState) {
      setState(() {
        _isLoading = true;
      });
    }
  }

  /// ACTIONS
  void _onClickedContinue(BuildContext blocContext) {
    if (_isLoading) return;

    setState(() {
      _verificationErr = null;
      _signInErr = null;
    });

    if (_step == LoginSteps.getPhone) {
      //we have the phone number
      _onSendOrResendCodeClicked(blocContext);
    } else {
      //we have an sms code
      AuthUserBloc event = BlocProvider.of<AuthUserBloc>(blocContext);
      event.add(SignInAuthUserEvent(
          verificationId: _verificationId, smsCode: _smsCode));
    }
  }

  bool _onBackPressed(BuildContext blocContext) {
    if (_step == LoginSteps.verifyPhone) {
      //go back to get phone
      AuthUserBloc event = BlocProvider.of<AuthUserBloc>(blocContext);
      event.add(SwitchLoginModeEvent(isInGetPhoneNotGetCodeMode: false));
      return false; //don't go back
    } else {
      return true;
    }
  }

  void _goToGetPhone(BuildContext blocContext) {
    AuthUserBloc event = BlocProvider.of<AuthUserBloc>(blocContext);
    event.add(SwitchLoginModeEvent(isInGetPhoneNotGetCodeMode: false));
  }

  void _onSendOrResendCodeClicked(BuildContext blocContext) {
    AuthUserBloc event = BlocProvider.of<AuthUserBloc>(blocContext);
    String phoneNumber = _phoneController.text;
    String countryCode = countryToPhoneCodeMap[_selectedCountry] ?? '';
    event.add(VerifyAuthUserEvent(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
        resendToken: _resendToken));
  }

  /// life cycle
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}

enum LoginSteps { getPhone, verifyPhone, signedIn }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redting/core/components/gradients/primary_gradients.dart';
import 'package:redting/core/components/screens/screen_container.dart';
import 'package:redting/core/components/selectors/country_selector.dart';
import 'package:redting/core/components/text_input/outlined_txtfield.dart';
import 'package:redting/features/auth/di/auth_di.dart';
import 'package:redting/features/auth/presentation/state/auth_user_bloc.dart';
import 'package:redting/res/countries.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
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

  @override
  void initState() {
    _phoneController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        lazy: false,
        create: (BuildContext blocProviderContext) =>
            authDiInstance<AuthUserBloc>(),
        child: BlocListener<AuthUserBloc, AuthUserState>(
          listener: (context, state) {
            if (state is LoadedAuthUserState) _goToHome();
          },
          child: ScreenContainer(
              child: Scaffold(
                  extendBodyBehindAppBar: true,
                  body: Container(
                    decoration:
                        BoxDecoration(gradient: threeColorOpaqueGradientTB),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: paddingMd, horizontal: paddingLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _getPhoneStepWidgets(),
                      ),
                    ),
                  ))),
        ));
  }

  _goToHome() {
    //todo navigate away
  }

  /// STEP 1 GET PHONE
  List<Widget> _getPhoneStepWidgets() {
    return [
      Text(
        loginTitle,
        style: appTextTheme.headline2,
      ),
      const SizedBox(
        height: paddingStd,
      ),
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
        visible: false, //todo
        child: Container(
          margin: const EdgeInsets.only(top: paddingSm),
          child: Text(
            phoneNumberErr,
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
      const SizedBox(
        height: paddingSm,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 200, maxWidth: 200),
            child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  loginBtn.toUpperCase(),
                  style: appTextTheme.button
                      ?.copyWith(fontWeight: FontWeight.w700),
                )),
          ),
        ],
      )
    ];
  }

  /// STEP 2 VERIFY PHONE

  /// STEP 3 VERIFIED, SIGN IN

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:redting/res/countries.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/theme.dart';

class CountrySelector extends StatefulWidget {
  final String selectedCountry;
  final Function(String country) onCountrySelected;
  const CountrySelector({
    Key? key,
    required this.selectedCountry,
    required this.onCountrySelected,
  }) : super(key: key);

  @override
  State<CountrySelector> createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  bool _isShowingPopUp = false;
  void _showCountrySelector() async {
    if (_isShowingPopUp) return;
    setState(() {
      _isShowingPopUp = true;
    });
    String? tappedCountry = await showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: countryToPhoneCodeMap.keys.map((String value) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, value);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: paddingSm),
                    child: Text(
                      value,
                      style:
                          appTextTheme.bodyText1?.copyWith(color: Colors.black),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (mounted) {
      setState(() {
        _isShowingPopUp = false;
      });
      if (tappedCountry != null) {
        widget.onCountrySelected(tappedCountry);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showCountrySelector();
      },
      splashColor: appTheme.colorScheme.inversePrimary,
      radius: 14.0,
      child: Container(
        height: 58,
        width: 70,
        margin: const EdgeInsets.only(right: paddingStd),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: const Border.fromBorderSide(
                BorderSide(color: Colors.grey, width: 1))),
        child: Center(
          child: Text(
            countryToPhoneCodeMap[widget.selectedCountry] ?? '',
            style: appTextTheme.headline5,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:redting/features/profile/domain/models/user_gender.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class GenderPreferences extends StatefulWidget {
  const GenderPreferences({Key? key}) : super(key: key);

  @override
  State<GenderPreferences> createState() => _GenderPreferencesState();
}

class _GenderPreferencesState extends State<GenderPreferences> {
  UserGender? _gender;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            showMeGendersAndPreferencesLbl,
            style: appTextTheme.headline4?.copyWith(color: Colors.black),
          ),
          const SizedBox(
            height: paddingStd,
          ),
          Wrap(
            runAlignment: WrapAlignment.spaceBetween,
            alignment: WrapAlignment.spaceBetween,
            children: [
              _getGender(value: UserGender.male, lbl: menLbl),
              _getGender(value: UserGender.female, lbl: womenLbl),
              _getGender(value: null, lbl: allGendersLbl),
            ],
          )
        ]);
  }

  Widget _getGender({required UserGender? value, required String lbl}) {
    return InkWell(
      splashColor: appTheme.colorScheme.secondary.withOpacity(0.1),
      radius: 8.0,
      borderRadius: BorderRadius.circular(8.0),
      onTap: () {
        setState(() {
          _gender = value;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: _gender == value
                    ? appTheme.colorScheme.primary
                    : Colors.black26,
                width: 1.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            lbl,
            style: appTextTheme.headline6?.copyWith(
              color: _gender == value
                  ? appTheme.colorScheme.primary
                  : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

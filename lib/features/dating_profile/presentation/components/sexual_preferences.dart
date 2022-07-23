import 'package:flutter/material.dart';
import 'package:redting/features/dating_profile/domain/models/sexual_orientation.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/string_maps.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class SexualPreferences extends StatefulWidget {
  const SexualPreferences({Key? key}) : super(key: key);

  @override
  State<SexualPreferences> createState() => _SexualPreferencesState();
}

class _SexualPreferencesState extends State<SexualPreferences> {
  Map<SexualOrientation, bool> _myPreferences = {};
  bool _makeMyOrientationPublic = true;
  bool _showMeMyOrientationOnly = true;

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        const SizedBox(
          height: paddingMd,
        ),
        Text(
          mySexualOrientation,
          style: appTextTheme.headline4?.copyWith(color: Colors.black),
        ),
        ..._getPreferences(),
        const SizedBox(
          height: paddingStd,
        ),
        SwitchListTile(
          visualDensity: VisualDensity.compact,
          dense: true,
          activeColor: appTheme.colorScheme.primary,
          title: Text(
            makeMyOrientationPublicLbl,
            style: appTextTheme.subtitle1,
          ),
          value: _makeMyOrientationPublic,
          onChanged: (bool value) {
            setState(() {
              _makeMyOrientationPublic = value;
            });
          },
        ),
        const SizedBox(
          height: paddingStd,
        ),
        SwitchListTile(
          visualDensity: VisualDensity.compact,
          dense: true,
          activeColor: appTheme.colorScheme.primary,
          title: Text(
            showMeMyOrientationOnly,
            style: appTextTheme.subtitle1,
          ),
          value: _showMeMyOrientationOnly,
          onChanged: (bool value) {
            setState(() {
              _showMeMyOrientationOnly = value;
            });
          },
        ),
        const SizedBox(
          height: paddingStd,
        ),
      ],
    );
  }

  List<Widget> _getPreferences() {
    List<Widget> orientationWidgets = sexualOrientationMap.entries
        .map((e) => _getPreference(e.value, e.key))
        .toList();
    return orientationWidgets;
  }

  Widget _getPreference(String lbl, SexualOrientation value) {
    return GestureDetector(
      onTap: () {
        bool alreadySelected = _myPreferences.containsKey(value);
        if (!alreadySelected) {
          _myPreferences[value] = true;
        } else {
          _myPreferences.remove(value);
        }
        if (mounted) {
          setState(() {
            _myPreferences = _myPreferences;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(
          top: paddingStd,
        ),
        height: 40,
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black12))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                lbl,
                style: appTextTheme.subtitle1?.copyWith(
                    color: _myPreferences.containsKey(value)
                        ? appTheme.colorScheme.primary
                        : Colors.black54),
              ),
            ),
            const SizedBox(
              width: paddingStd,
            ),
            Icon(
              Icons.check,
              color: _myPreferences.containsKey(value)
                  ? appTheme.colorScheme.primary
                  : Colors.black12,
              size: 24,
            )
          ],
        ),
      ),
    );
  }
}

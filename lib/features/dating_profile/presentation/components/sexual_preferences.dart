import 'package:flutter/material.dart';
import 'package:redting/features/dating_profile/domain/models/sexual_orientation.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/string_maps.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class SexualPreferences extends StatefulWidget {
  final List<SexualOrientation> orientationPreferences;
  final Function(List<SexualOrientation> orientationPreferences)
      onUpdatedPreferences;
  final bool makeMyOrientationPublic;
  final bool showMeMyOrientationOnly;
  final Function(bool value) onUpdateRestrictions;
  final Function(bool value) onUpdateVisibility;
  const SexualPreferences(
      {Key? key,
      required this.orientationPreferences,
      required this.onUpdatedPreferences,
      required this.onUpdateRestrictions,
      required this.onUpdateVisibility,
      required this.makeMyOrientationPublic,
      required this.showMeMyOrientationOnly})
      : super(key: key);

  @override
  State<SexualPreferences> createState() => _SexualPreferencesState();
}

class _SexualPreferencesState extends State<SexualPreferences> {
  Map<SexualOrientation, bool> _myPreferences = {};
  bool _makeMyOrientationPublic = true;
  bool _showMeMyOrientationOnly = true;

  @override
  void initState() {
    _myPreferences.clear();
    _myPreferences.addEntries(
        widget.orientationPreferences.map((e) => MapEntry(e, true)));
    _makeMyOrientationPublic = widget.makeMyOrientationPublic;
    _showMeMyOrientationOnly = widget.showMeMyOrientationOnly;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        const SizedBox(
          height: paddingMd,
        ),
        Text(
          mySexualOrientation,
          style: appTextTheme.subtitle1?.copyWith(color: Colors.black),
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
            style: appTextTheme.bodyText1,
          ),
          value: _makeMyOrientationPublic,
          onChanged: (bool value) {
            setState(() {
              _makeMyOrientationPublic = value;
            });
            widget.onUpdateVisibility(value);
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
            style: appTextTheme.bodyText1,
          ),
          value: _showMeMyOrientationOnly,
          onChanged: (bool value) {
            setState(() {
              _showMeMyOrientationOnly = value;
            });
            widget.onUpdateRestrictions(value);
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
          widget.onUpdatedPreferences(
              _myPreferences.keys.toList(growable: false));
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
                style: appTextTheme.bodyText1?.copyWith(
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

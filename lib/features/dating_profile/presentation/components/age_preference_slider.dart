import 'package:flutter/material.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class AgePreferenceSlider extends StatefulWidget {
  const AgePreferenceSlider({Key? key}) : super(key: key);

  @override
  State<AgePreferenceSlider> createState() => _AgeSliderState();
}

class _AgeSliderState extends State<AgePreferenceSlider> {
  RangeValues _currentRangeAge = const RangeValues(20, 50);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$ageRangeLbl ${_currentRangeAge.start.round().toString()} - ${_currentRangeAge.end.round().toString()}",
          style: appTextTheme.headline4?.copyWith(color: Colors.black),
        ),
        const SizedBox(
          height: paddingStd,
        ),
        SliderTheme(
          data: SliderThemeData(
              valueIndicatorTextStyle: appTextTheme.headline6,
              valueIndicatorColor:
                  appTheme.colorScheme.primary.withOpacity(0.6),
              showValueIndicator: ShowValueIndicator.always),
          child: RangeSlider(
            values: _currentRangeAge,
            max: 100,
            divisions: (100 - 18),
            min: 18,
            labels: RangeLabels(
              _currentRangeAge.start.round().toString(),
              _currentRangeAge.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeAge = values;
              });
            },
          ),
        )
      ],
    );
  }
}

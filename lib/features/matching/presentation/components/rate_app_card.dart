import 'package:flutter/material.dart';
import 'package:redting/core/components/buttons/main_elevated_btn.dart';
import 'package:redting/core/components/cards/glass_card.dart';
import 'package:redting/core/utils/consts.dart';
import 'package:redting/res/dimens.dart';
import 'package:redting/res/fonts.dart';
import 'package:redting/res/strings.dart';
import 'package:redting/res/theme.dart';

class RateAppCard extends StatefulWidget {
  final bool isSendingFeedback;
  final void Function(int rating, String feedback) onSubmitFeedback;
  const RateAppCard(
      {Key? key,
      required this.isSendingFeedback,
      required this.onSubmitFeedback})
      : super(key: key);

  @override
  State<RateAppCard> createState() => _RateAppCardState();
}

class _RateAppCardState extends State<RateAppCard> {
  int _rating = 3;
  String _feedback = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;
    return GlassCard(
      wrapInChildScrollable: false,
      constraints: BoxConstraints(
        maxWidth: screenWidth - 40,
        minWidth: 300,
        minHeight: screenHeight * 0.4,
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                noMoreProfiles,
                textAlign: TextAlign.justify,
                style: appTextTheme.subtitle2,
              ),
              const SizedBox(
                height: paddingStd,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _getRatingStars(),
              ),
              const SizedBox(
                height: paddingStd,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: screenHeight * 0.3),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  onChanged: (newVal) {
                    if (mounted) {
                      setState(() {
                        _feedback = newVal;
                      });
                    }
                  },
                  minLines: 3,
                  maxLines: 5,
                  style:
                      appTextTheme.bodyText1?.copyWith(color: Colors.black87),
                  decoration: InputDecoration(
                      isDense: true,
                      hintText: feedbackHint,
                      hintStyle: appTextTheme.caption),
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: paddingMd),
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: MainElevatedBtn(
                      onPressed: () {
                        if (!widget.isSendingFeedback) {
                          widget.onSubmitFeedback(_rating, _feedback);
                        }
                      },
                      showLoading: widget.isSendingFeedback,
                      lbl: submitFeedbackBtn),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getRatingStars() {
    List<Widget> stars = [];
    int i = 0;
    while (i < maxStarsForRating) {
      final starNum = i + 1;
      stars.add(IconButton(
          iconSize: 32,
          onPressed: () {
            setState(() {
              _rating = starNum;
            });
          },
          icon: Icon(
            Icons.star_rounded,
            color: _rating >= starNum
                ? appTheme.colorScheme.primary
                : Colors.black26,
          )));
      i++;
    }
    return stars;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redting/res/fonts.dart';

class SixDigitCodeInput extends StatefulWidget {
  final Function(String code) onUpdateCode;
  const SixDigitCodeInput({Key? key, required this.onUpdateCode})
      : super(key: key);

  @override
  State<SixDigitCodeInput> createState() => _SixDigitCodeInputState();
}

class _SixDigitCodeInputState extends State<SixDigitCodeInput> {
  List<String> code = ["", "", "", "", "", ""];
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    _initControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _getInputs(),
    );
  }

  List<Widget> _getInputs() {
    List<Widget> widgets = [];
    for (int i = 0; i < 6; i++) {
      widgets.add(ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 48),
          child: TextField(
            style: appTextTheme.headline4,
            textAlign: TextAlign.center,
            controller: _controllers[i],
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (digit) {
              if (digit.length == 1 && i != 5) {
                FocusScope.of(context).nextFocus();
              }

              if (digit.isEmpty && i != 0) {
                FocusScope.of(context).previousFocus();
              }

              _updateCode(digit: digit, pos: i);
            },
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                isDense: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          )));
    }
    return widgets;
  }

  void _initControllers() {
    int i = 0;
    while (i < 6) {
      _controllers.add(TextEditingController()..text = code[i]);
      i++;
    }
  }

  @override
  void dispose() {
    for (var element in _controllers) {
      element.dispose();
    }
    super.dispose();
  }

  void _updateCode({required int pos, required String digit}) {
    setState(() {
      code[pos] = digit.isNotEmpty ? digit[0] : "";
      widget.onUpdateCode(code.join());
    });
  }
}

import 'package:flutter/material.dart';

class CustomStatefulBuilder extends StatefulWidget {
  final StatefulWidgetBuilder builder;

  const CustomStatefulBuilder({
    required Key key,
    required this.builder,
  }) : super(key: key);

  @override
  State<CustomStatefulBuilder> createState() => _CustomStatefulBuilderState();
}

class _CustomStatefulBuilderState extends State<CustomStatefulBuilder> {
  bool isMounted = false;
  @override
  Widget build(BuildContext context) => widget.builder(context, (callback) {
        isMounted = mounted;
        if (mounted) {
          setState(callback);
        }
      });
}

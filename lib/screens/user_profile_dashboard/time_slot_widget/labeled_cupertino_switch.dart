import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LabeledCupertinoSwitch extends StatefulWidget {
  const LabeledCupertinoSwitch({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  _LabeledCupertinoSwitchState createState() => _LabeledCupertinoSwitchState();
}

class _LabeledCupertinoSwitchState extends State<LabeledCupertinoSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.label,
        ),
        CupertinoSwitch(
          value: widget.value,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
